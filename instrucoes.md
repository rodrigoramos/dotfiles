Instalei

Via APT

- git
- vim-gtk
- i3
- i3blocks
- terminator
- compton
- python-pip
- fonts-firacode


Via GitHub
- Clonar:
https://github.com/tobi-wan-kenobi/bumblebee-status
- instalar módulo python (pip install) psutil e netifaces

https://github.com/ryanoasis/nerd-fonts

Instalação Manual (GAPS)

1. Instalar dependências
```
sudo apt install libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev
```

0. Instalar autoconf
```
sudo apt install autoconf
```

0. Biblioteca faltando
```
sudo apt install libxcb-shape0-dev
```

0. Clonar o gaps
```
git clone https://www.github.com/Airblader/i3 i3-gaps 
```

0. Build e Instalar
```
cd i3-gaps
git checkout gaps && git pull 
autoreconf --force --install 
rm -rf build 
mkdir build 
cd build 
../configure --prefix=/usr --sysconfdir=/etc 
make 
sudo make install
```

Ajuste do .bashrc

1. Alterar o tema
```
# Mudar de:
export BASH_IT_THEME="bobby"

# Para:
export BASH_IT_THEME="powerline-multiline"
```

0. Iniciação do tmux
```
# Start ou Attach tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  isMainSessionAttached=$(tmux list-sessions | grep -oP "main: .*[(attached)]$")
  if [ -z "$isMainSessionAttached" ]; then
    exec tmux new-session -A -s main
  else
    detachedSessionId=$(tmux list-sessions | grep -oPm 1 "([0-9]+?)(?=: .+[^(attached)]$)")
    if [ -n "$detachedSessionId" ]; then
      exec tmux new-session -A -s $detachedSessionId
    else
      exec tmux new-session
    fi
  fi
fi
```
