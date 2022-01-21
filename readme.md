# Meus dotfiles

NOTA: Esse repositório utilizar submodulo (dotbot).

Esse repositório possui meus arquivos de configuração bem como a montagem de ambiente.

Componentes:
- Sway
- Alacritty
- NeoVim
- Waybar
- Rider
- Xkb
- Tmux
- Bash-it


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
