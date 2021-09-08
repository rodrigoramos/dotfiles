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

