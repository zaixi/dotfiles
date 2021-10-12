if [[ ! -f $HOME/.dotfiles/.zshrc ]]; then
   print -P "%F{33}▓▒░ %F{220}Installing dotfiles (%F{33}zaixi/dotfiles%F{220})…%f"
   command git clone https://github.com/zaixi/dotfiles "$HOME/.dotfiles" && \
     print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
     print -P "%F{160}▓▒░ The clone has failed.%f%b"
else
   source $HOME/.dotfiles/.zshrc.common
fi

if [[ -f "$HOME/.zshrc.local" ]]; then
   source $HOME/.zshrc.local
fi
export PATH=$PATH:/opt/tools/gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu/bin
export PATH=$PATH:/opt/arm/developmentstudio-2020.0/bin
export PATH=$PATH:/opt/arm/developmentstudio-2020.0/sw/ARMCompiler6.14/bin
export ARMLMD_LICENSE_FILE="8224@127.0.0.1"
export ARM_PRODUCT_DEF=/opt/hobot/fpga/cv_script/ds5/bin/gold.elmap
