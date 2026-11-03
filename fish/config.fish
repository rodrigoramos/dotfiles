function _node_version
    # Check if node is installed and return its version in a format you like
    if command -v node > /dev/null
        echo (node -v)
    end
end

# function fish_prompt -d "Write out the prompt"
#     # This shows up as USER@HOST /home/user/ >, with the directory colored
#     # $USER and $hostname are set by fish, so you can just use them
#     # instead of using `whoami` and `hostname`
#     printf '%s@%s %s%s%s > ' $USER $hostname \
#         (set_color $fish_color_cwd) (prompt_pwd) (_node_version) (set_color normal)
# end

set -xg XDG_DATA_DIRS $XDG_DATA_DIRS /home/rodrigo.silva/.local/share/applications /var/lib/snapd/desktop/applications

set -xg nvmrc_announce false
set -xg PATH $PATH $HOME/.nix-profile/bin $HOME/.local/bin
set -gx EDITOR nvim
set -gx QT_QPA_PLATFORMTHEME qt5ct

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias ls 'eza --icons=auto'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'
    source ~/git/dotfiles/aliases
end

# for file in /etc/profile.d/*.sh
#     bass source $file
# end
