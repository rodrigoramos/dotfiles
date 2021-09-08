# Referência para Instalação

Principais aplicativos que costumo instalar. Foi utilizado a imagem da comunidade do Manjaro Sway como base.

## KeePassXC (habilitar senhas)
    1. Instalar Rclone via pacman
    0. Setup (rclone config) para OneDrive-Pessoal
    0. Setup Systemd [https://github.com/rclone/rclone/wiki/Systemd-rclone-mount]
       1. dotfiles .config/rclone/OneDrive-Pessoal.env
       0. Criar o arquivo rclone@.service em /etc/systemd/user
       0. `systemctl --user daemon-reload``
       0. `systemctl --user enable rclone@OneDrive-Pessoal.service`
       0. `systemctl --user start rclone@OneDrive-Pessoal.service`
    0. Instalar o KeePass
       ```bash
       $ sudo pacman -S keepassxc
       ```

## SSH
   1. Criar nova chave ssh local
   ```bash
   $ ssh-keygen
   ```
   2. Adicionar chave pública no GitHub 


## Dotfiles
   1. Verificar se a pasta ~/.xkb/symbols existe;
   0. Remover arquivos (ou fazer backup) da pasta ~/.config/waybar
   0. Clone repo
   0. Run install
      ```bash
      ./install -v
      ```
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
   ```
   yay -S headsetcontrol
   ```
   - Ripgrep (rg) - necessário para o meu NeoVim
   ```bash
   pacman -S ripgrep
   ```
   - Chromium
   ```bash
   pacman -S chromium
   ```
   - bat
   ```bash
   pacman -S bat
   ```

