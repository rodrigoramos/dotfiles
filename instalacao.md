# Passo a Passo Instalacao

1. KeePassXC (habilitar senhas)
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

0. SSH
   1. Criar nova chave ssh local
   ```bash
   $ ssh-keygen
   ```
   2. Adicionar chave pública no GitHub 


0. Dotfiles
   1. Verificar se a pasta ~/.xkb/symbols existe;
   0. Remover arquivos (ou fazer backup) da pasta ~/.config/waybar
   0. Clone repo
   0. Run install
      ```bash
      ./install -v
      ```
0. Setup NeoVim
   1. Open NeoVim
   ```bash
   nvim
   ```
   0. Ignore os erros
   0. Install Plugins:
   ```
   :PlugInstall
   ```

0. Instalar programas:
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


