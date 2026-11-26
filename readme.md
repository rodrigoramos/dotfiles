# Meus dotfiles

NOTA: Esse repositório utiliza submódulo (dotbot).

Esse repositório possui meus arquivos de configuração bem como a montagem de ambiente,
para Linux e macOS na mesma branch (`master`).

## Instalação

```sh
git clone --recursive git@github.com:rodrigoramos/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles && ./install
```

O `./install` detecta o sistema e aplica:

| Arquivo | Conteúdo |
|---|---|
| `install.conf.yaml` | comum: nvim, vim, ideavim, git, fish, kitty |
| `install.linux.yaml` | Hyprland, Waybar, Sway, systemd, xkb, Xresources |
| `install.macos.yaml` | Rift, SketchyBar, Karabiner + `brew bundle` com `macos/Brewfile` |

Diferenças por sistema dentro de uma mesma config ficam no próprio arquivo:
- fish: blocos `if test (uname) = Linux`
- kitty: `kitty.conf` comum + `linux.conf` / `macos.conf` (via `include ${KITTY_OS}.conf`)

Atalhos de janela compartilhados entre Hyprland e Rift: ver `keymap.md`.

### Primeira vez no macOS

1. Instalar o [Homebrew](https://brew.sh) e rodar `./install`.
2. Tornar o fish o shell padrão: `echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells && chsh -s /opt/homebrew/bin/fish`.
3. Instalar o fisher e os plugins do fish (o `fisher.fish` não é versionado): `fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update'`.
   O `pgcli` vem do pipx: `pipx install pgcli`.
4. Dar permissão de Acessibilidade ao Rift.

## Manual Fixes

### NeoVim

#### Barbar's wrong tab color

1. Go to ~/.vim/plugged/barbar.nvim/autoload/bufferline/highlight.vim
2. Change the lines from:
   ```
   let fg_current  = s:fg(['Normal'], '#efefef')
   let fg_visible  = s:fg(['TabLineSel'], '#efefef')
   ```
   To:
   ```
   let fg_current  = s:fg(['TabLineSel'], '#efefef')
   let fg_visible  = s:fg(['TabLine'], '#efefef')
   ```
3. Also change from:
   ```
   let bg_current  = s:bg(['Normal'], 'none')
   let bg_visible  = s:bg(['TabLineSel', 'Normal'], 'none')
   ```
   To:
   ```
   let bg_current  = s:bg(['TabLineSel'], 'none')
   let bg_visible  = s:bg(['TabLine', 'Normal'], 'none')
   ```

### Sway

1. Open with super user the file /etc/sway/modes/default
0. Change the line from:
   ```
   $bindsym $mod+Shift+p exec $clipboard
   ```
   to:
   ```
   $bindsym $mod+Ctrl+v exec $clipboard
   ```
0. Change the lines from:
   ```
   ## Setting // Split windows horizontally ##
   $bindsym $mod+b splith
   ## Setting // Split windows vertically ##
   $bindsym $mod+v splitv
   ```
   to: 
   ```
   ## Setting // Split windows horizontally ##
   $bindsym $mod+Shift+h splith
   ## Setting // Split windows vertically ##
   $bindsym $mod+Shift+v splitv
   ```
