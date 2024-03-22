#! /bin/bash

#sudo apt-get install python3-pip
# base
sudo apt-get install -y zsh curl gawk gcc git gzip less make tar tmux trash-cli unzip vim wget whois zip tree ripgrep
# extend
sudo apt-get install -y bzip2 dos2unix htop httping iftop iotop nmap openssl rsync sshfs sshpass snap
# docker
sudo apt-get install -y docker-compose linux-image-extra-virtual  linux-modules-extra-$(uname -r)
# progress(cp mv dd ...进度显示)
sudo apt-get install -y libncurses5-dev libappindicator1 libindicator7 progress
# qemu
sudo apt-get install -y uml-utilities bridge-utils qemu
# zerotier-cli
curl -s https://install.zerotier.com/ | sudo bash;zerotier-cli join 12ac4a1e7108528f
# bcompare
sudo apt-get install -y bcompare
# neovim
mkdir -p ~/.local/bin
nvim_version=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
wget https://github.com/neovim/neovim/releases/download/v${nvim_version=}/nvim.appimage -O ~/.local/bin/nvim
git clone https://github.com/zaixi/LazyVim ~/.config/nvim

pip3 install mackup

ln -s -f ~/.dotfiles/.mackup.cfg ~/
ln -s -f ~/.dotfiles/.mackup ~/
chsh -s /bin/zsh
