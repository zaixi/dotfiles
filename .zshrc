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
