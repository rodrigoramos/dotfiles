#!/usr/bin/env bash
# Tela de bloqueio: wallpaper atual + agenda do dia (khal) no canto inferior esquerdo
# e relógio no canto inferior direito, só no monitor primário (os outros ficam pretos).
# Com i3lock-color o relógio é ao vivo; com o i3lock padrão a hora fica "congelada" na imagem.

set -u

FONT_FILE="JetBrainsMono-NF-Regular"
FONT_BOLD="JetBrainsMono-NF-Bold"
FONT_NAME="JetBrainsMono Nerd Font"
MARGIN=60
MAX_EVENTS=4
IMG="${XDG_RUNTIME_DIR:-/tmp}/lockscreen"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/lockscreen"

# khal é a etapa mais lenta: começa já, em paralelo com o resto
khal_out=$(mktemp)
khal list --format "{end-time}|{cancelled}|{start-end-time-style}  {title}" --day-format "" today today \
  >"$khal_out" 2>/dev/null &
khal_pid=$!

# Wallpaper atual: último caminho entre aspas em ~/.fehbg
wallpaper=$(grep -o "'[^']*'" "$HOME/.fehbg" 2>/dev/null | tail -1 | tr -d "'")
key=$(printf '%s' "$wallpaper$(stat -c %Y "$wallpaper" 2>/dev/null)" | md5sum | cut -c1-12)

if i3lock --version 2>&1 | grep -q '\.c\.'; then
  color=1
else
  color=0
fi

# Só o monitor primário recebe wallpaper, agenda e relógio; os outros ficam pretos.
# "idx w h x y" — idx é a posição na lista do RandR, a mesma ordem que o i3lock-color usa em --screen.
read -r mon_idx w h x y < <(xrandr --current --listmonitors | awk 'NR > 1 {
  split($3, g, /[\/x+]/); line = NR - 2 " " g[1] " " g[3] " " g[5] " " g[6]
  if (!first) first = line
  if ($2 ~ /\*/) { print line; found = 1; exit } }
  END { if (!found) print first }')

# Fundo da resolução do primário (wallpaper em fill + degradê escuro embaixo), em cache.
# MIFF sem compressão carrega bem mais rápido que PNG.
mkdir -p "$CACHE_DIR"
bg="$CACHE_DIR/$key-${w}x${h}.miff"
if [ ! -f "$bg" ]; then
  convert \
    \( "$wallpaper" -resize "${w}x${h}^" -gravity center -extent "${w}x${h}" \) \
    \( -size "${w}x$((h / 2))" gradient:'#00000000-#000000b0' \) \
    -gravity South -composite -depth 8 "$bg.tmp.miff" && mv "$bg.tmp.miff" "$bg"
fi
wait "$khal_pid"

# Agenda do dia: só eventos que ainda não terminaram (os em andamento entram), sem cancelados
agenda=$(awk -F'|' -v now="$(date +%H:%M)" '
    $1 != "" && $1 > now && $2 == "" && $3 !~ /^[0-9:-]+  (Evento cancelado|Cancel+ed( event)?)[: ]/ {
      sub(/^[^|]*\|[^|]*\|/, ""); print
    }' "$khal_out" | cut -c1-60 | head -n "$MAX_EVENTS")
rm -f "$khal_out"
[ -z "$agenda" ] && agenda="Nenhum evento restante hoje"
header="Agenda · $(LC_TIME=pt_BR.UTF-8 date '+%A, %d/%m')"
lines=$(printf '%s\n' "$agenda" | wc -l)

# Fontes e margens escalam com o lado menor do monitor (1080 px = escala 1)
short=$(( w < h ? w : h ))
s() { echo $(( $1 * short / 1080 )); }
margin=$(s "$MARGIN")
args=("$bg" -gravity SouthWest
  -font "$FONT_FILE" -pointsize "$(s 15)" -interline-spacing "$(s 7)" -fill '#ffffffe6'
  -annotate "+$margin+$margin" "$agenda"
  -font "$FONT_BOLD" -pointsize "$(s 18)" -fill white
  -annotate "+$margin+$((margin + $(s 27) * lines + $(s 16)))" "$header")
if [ "$color" = 0 ]; then
  # Fallback: hora estática desenhada na imagem
  args+=(-gravity SouthEast
    -font "$FONT_BOLD" -pointsize "$(s 96)" -annotate "+$margin+$((margin + $(s 40)))" "$(date +%H:%M)"
    -font "$FONT_FILE" -pointsize "$(s 26)" -fill '#ffffffcc' -annotate "+$margin+$margin" "$(LC_TIME=pt_BR.UTF-8 date '+%A, %d de %B')")
fi

# O i3lock desenha a imagem a partir de 0,0 sobre fundo preto (-c 000000). A imagem vai só
# até o canto inferior direito do primário (área à esquerda/acima dele fica preta), para
# carregar o mínimo de dados a cada redesenho.
img_w=$((x + w)); img_h=$((y + h))
if [ "$x" != 0 ] || [ "$y" != 0 ]; then
  args=(-size "${img_w}x${img_h}" xc:black \( "${args[@]}" \) -gravity NorthWest -geometry "+$x+$y" -composite)
fi

# i3lock-color lê imagem raw (bem mais rápido que codificar PNG)
if [ "$color" = 1 ]; then
  IMG="$IMG.raw"
  convert "${args[@]}" -depth 8 rgb:"$IMG"
  img_args=(-c 000000 -i "$IMG" --raw="${img_w}x${img_h}:rgb")
else
  IMG="$IMG.png"
  convert "${args[@]}" -define png:compression-level=1 "$IMG"
  img_args=(-c 000000 -i "$IMG")
fi
# O i3lock lê a imagem só na inicialização; depois disso ela pode sair da RAM (/run/user é tmpfs)
(sleep 10; rm -f "$IMG") >/dev/null 2>&1 &

if [ "$color" = 1 ]; then
  # --redraw-thread: redesenho fora da thread de entrada, para a digitação não travar.
  # --refresh-rate: o relógio só mostra HH:MM; redesenhar a cada 50 s (em vez de 1 s)
  # tira redesenhos da tela inteira que competem com os da digitação.
  exec i3lock --nofork "${img_args[@]}" \
    --redraw-thread --refresh-rate=50 \
    --screen=$((mon_idx + 1)) \
    --clock --force-clock \
    --time-str="%H:%M" --date-str="%A, %d de %B" \
    --time-font="$FONT_NAME" --date-font="$FONT_NAME" \
    --time-size=96 --date-size=26 \
    --time-color=ffffffff --date-color=ffffffcc \
    --time-align=2 --date-align=2 \
    --time-pos="x+w-$MARGIN:y+h-$((MARGIN + 50))" \
    --date-pos="tx:ty+45" \
    --ind-pos="x+w/2:y+h/2" \
    --inside-color=00000066 --ring-color=ffffff99 --line-uses-inside \
    --keyhl-color=ffffffff --bshl-color=ff6666ff --separator-color=00000000 \
    --insidever-color=00000088 --ringver-color=ffffffcc \
    --insidewrong-color=ff666666 --ringwrong-color=ff6666ff \
    --verif-color=ffffffff --wrong-color=ffffffff \
    --verif-text="..." --wrong-text="senha errada" --noinput-text="" \
    --verif-font="$FONT_NAME" --wrong-font="$FONT_NAME" \
    "$@"
else
  exec i3lock --nofork "${img_args[@]}" "$@"
fi
