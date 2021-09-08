# Referência para Instalação

Principais aplicativos que costumo instalar. Foi utilizado a imagem da comunidade do Manjaro Sway como base.

## Dotfiles
   1. Garanta que a pasta `~/.xkb/symbols` existe
   0. Remover arquivos (ou fazer backup) da pasta `~/.config/waybar`
   0. Clone repo
      ```bash
      git clone git@github.com:rodrigoramos/dotfiles.git
      ```
   0. Run install
      ```bash
      cd dotfiles && ./install -v
      ```

## Rclone + KeePassXC (habilitar senhas)

1. Instalar Rclone via pacman
    ```bash
    pacman -S rclone
    ```
0. Setup (rclone config) para OneDrive-Pessoal
0. Setup Systemd [https://github.com/rclone/rclone/wiki/Systemd-rclone-mount]
   1. Garanta que esse arquivo existe: `.config/rclone/OneDrive-Pessoal.env` (proveniente do dotfiles)
   0. Criar o arquivo rclone@.service em /etc/systemd/user
   0. Reiniciar o Daemon 
      `systemctl --user daemon-reload`
   0. Habilitar o Serviço
      `systemctl --user enable rclone@OneDrive-Pessoal.service`
   0. Reiniciar o Serviço
      `systemctl --user start rclone@OneDrive-Pessoal.service`
0. Instalar o KeePass
   ```bash
   sudo pacman -S keepassxc
   ```

## SSH
   1. Criar nova chave ssh local
      ```bash
      ssh-keygen
      ```
   2. Adicionar chave pública no GitHub [https://github.com/settings/keys]


## Instalar NVM (Node e NPM)
   1. Instalar NVM
      ```bash
      pacman -S nvm
      ```
   0. Edit the .zshrc (or .bashrc)
      ```bash
      echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc
      ```
   0. Restart the shell
   0. Install Node/NPM
      ```bash
      nvm install --lts
      ```
   0. Definir instalação como default
      ```bash
      nvm alias default $(node --version)
      ```

## Setup NeoVim
   1. Open NeoVim
      ```bash
      nvim
      ```
   0. Ignore os erros
   0. Install Plugins:
      ```
      :PlugInstall
      ```

## Outros Programas Utilizados
   - headsetcontrol (AUR)
   - Ripgrep (rg) - necessário para a config do NeoVim
   - Chromium
   - bat
   ```
   yay -S headsetcontrol ripgrep chromium bat
   ```

