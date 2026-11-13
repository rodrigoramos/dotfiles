#!/bin/bash
# Atualiza os itens ws.N a partir do Rift: visibilidade, monitor e destaque.
source "$CONFIG_DIR/colors.sh"

WS=$(/opt/homebrew/bin/rift-cli query workspaces 2>/dev/null) || exit 0
DISPLAYS=$(/opt/homebrew/bin/sketchybar --query displays)

args=()
while IFS=$'\t' read -r idx uuid count active focused; do
  # UUID do display (Rift) -> id de arranjo do SketchyBar
  disp=$(echo "$DISPLAYS" | /opt/homebrew/bin/jq -r --arg u "$uuid" \
    '[.[] | select(.UUID == $u)][0]["arrangement-id"] // empty')

  if [ "$count" -gt 0 ] || [ "$active" = "true" ]; then
    draw=on
  else
    draw=off
  fi

  if [ "$focused" = "true" ]; then
    bg=$ACCENT; fg=$ON_ACCENT
  elif [ "$active" = "true" ]; then
    bg=$BG_ACTIVE; fg=$FG
  else
    bg=$BG; fg=$FG_DIM
  fi

  args+=(--set "ws.$idx" drawing=$draw background.color=$bg label.color=$fg)
  [ -n "$disp" ] && args+=(display="$disp")
done < <(echo "$WS" | /opt/homebrew/bin/jq -r \
  '.[] | [(.index + 1), .display_uuid, .window_count, .is_active, .is_focused] | @tsv')

/opt/homebrew/bin/sketchybar "${args[@]}"
