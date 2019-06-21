##!/bin/zsh -f
#zmodload zsh/zprof

# 安装和更新 {{{
# Install Plugin manager if not exist
if [ ! -x "$(which antibody)" ]; then
    echo "Installing antibody..."
    URL="git.io/antibody"
    if [ -x "$(which curl)" ]; then
		curl -sL "$URL" | sudo sh -s
    else
        echo "ERROR: please install curl before installation !!"
        exit
    fi
    if [ ! $? -eq 0 ]; then
        echo ""
        echo "ERROR: downloading antibody ($URL) failed !!"
        exit
	fi
fi

function _upgrade_plugin() {
  antibody update
  cd "$HOME/.fzf" && git pull && ./install --bin && cd -
  pip3 install thefuck --upgrade
  sudo pip3 install thefuck --upgrade
}

function check_for_upgrade() {
	Plugin_Cache_Dir="$HOME/.cache/zsh_plugin_update"
	if mkdir -p "$Plugin_Cache_Dir/update.lock" 2>/dev/null; then
		. ${Plugin_Cache_Dir}/.zsh-update 2>/dev/null
		zmodload zsh/datetime
		NOW_TIME=$(( $EPOCHSECONDS / 60 / 60 / 24 ))
		if [[ -z "$LAST_TIME" ]]; then
			echo "LAST_TIME=$NOW_TIME" >! ${Plugin_Cache_Dir}/.zsh-update
		else
			epoch_target=15
			epoch_diff=$(($NOW_TIME - $LAST_TIME))
			if [ $epoch_diff -gt $epoch_target ]; then
				echo "Plugin starts to install or upgrade...\n"
				_upgrade_plugin
				echo "LAST_TIME=$NOW_TIME" >! ${Plugin_Cache_Dir}/.zsh-update
			fi
		fi
	  rmdir $Plugin_Cache_Dir/update.lock
	fi
}
check_for_upgrade

#}}}

# 个人设置加载 {{{
# Load local bash/zsh compatible settings
_INIT_SH_NOFUN=1
[ -f "$HOME/.local/etc/init.sh" ] && source "$HOME/.local/etc/init.sh"

# exit for non-interactive shell
#[[ $- != *i* ]] && return

# WSL (aka Bash for Windows) doesn't work well with BG_NICE
[ -d "/mnt/c" ] && [[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE

#}}}
#export TERM=xterm-256color
# 插件 {{{
source <(antibody init)
ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"
antibody bundle changyuheng/fz
function _z() { _zlua "$@"; }
antibody bundle robbyrussell/oh-my-zsh
antibody bundle "
robbyrussell/oh-my-zsh path:plugins/common-aliases
robbyrussell/oh-my-zsh path:plugins/colorize
robbyrussell/oh-my-zsh path:plugins/fzf
robbyrussell/oh-my-zsh path:plugins/colored-man-pages
robbyrussell/oh-my-zsh path:plugins/last-working-dir
robbyrussell/oh-my-zsh path:plugins/extract
robbyrussell/oh-my-zsh path:plugins/repo
robbyrussell/oh-my-zsh path:plugins/cp
#robbyrussell/oh-my-zsh path:plugins/thefuck
"

antibody bundle zsh-users/zsh-history-substring-search
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zsh-users/zsh-completions
antibody bundle unixorn/autoupdate-antigen.zshplugin
antibody bundle zsh-users/zsh-syntax-highlighting
antibody bundle mafredri/zsh-async
antibody bundle skywind3000/z.lua

# 主题
#
# powerline
#
#POWERLEVEL9K_VCS_GIT_HOOKS=()
#POWERLEVEL9K_MODE=flat
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator)
POWERLEVEL9K_STATUS_OK=false
#antibody bundle "bhilburn/powerlevel9k"
#antibody bundle "robobenklein/p10k"
#
# normal
#
antibody bundle zaixi/pure

#}}}

# thefuck {{{
if [[ -z $commands[thefuck] ]]; then
    echo 'thefuck is not installed, you should "pip install thefuck" or "brew install thefuck" first.'
    echo 'See https://github.com/nvbn/thefuck#installation'
    return 1
fi

fuck-command-line() {
    local FUCK="$(THEFUCK_REQUIRE_CONFIRMATION=0 thefuck $(fc -ln -1 | tail -n 1) 2> /dev/null)"
    [[ -z $FUCK ]] && echo -n -e "\a" && return
    BUFFER=$FUCK
    zle end-of-line
}
zle -N fuck-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" fuck-command-line

# }}}

# fzf {{{
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_OPTS="
--color fg:-1,bg:-1,hl:33,fg+:254,bg+:235,hl+:33
--color info:136,prompt:136,pointer:230,marker:230,spinner:136
"
export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion

# fuzzy grep open via ag with line number
vg() {
  local file
  local line

  #read -r file line <<<"$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"
  read -r file line <<<"$(ag --nobreak --noheading --color $@ | fzf -0 -1 --ansi | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]
  then
     vim $file +$line
  fi
}

j() {
	if [[ "$#" -ne 0 ]]; then
		z $@
		return
	fi
	cd "$(z -l | sed '/_____/Q; s/^[0-9,.:]*\s*//' |  fzf --height 40% --reverse --inline-info)"
}
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}
#}}}

# 自动补全 {{{

eval "$(dircolors ~/.dircolors)"
# ignore complition
zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.pdf|*.exe|*.dll'
zstyle ':completion:*:*sh:*:' tag-order files

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'

# }}}

# 语法高亮: {{{
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

typeset -A ZSH_HIGHLIGHT_STYLES

# ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
# }}}

# zsh选项 {{{

#以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
unsetopt correct_all

HISTFILE=$HOME/.zsh_history
#setopt extended_history          # 在历史文件中记录命令的时间戳
#setopt hist_expire_dups_first    # 当历史文件就大小超过大小时，首先删除重复项
#setopt hist_ignore_dups          # 如果连续输入的命令相同，历史纪录中只保留一个
#setopt hist_ignore_space         # 忽略以空格开头的命令
#setopt hist_verify               # 历史扩展后不立即执行
#setopt inc_append_history        # 立即写入历史文件,而不是退出时才写入
#setopt share_history             # 共享zsh历史
setopt hist_expand               # 扩展历史

setopt HIST_IGNORE_ALL_DUPS      # 删除重复命令
setopt HIST_FIND_NO_DUPS         # 不显示先前找到的行
setopt HIST_SAVE_NO_DUPS         # 不要在历史文件中写入重复的条目
setopt hist_reduce_blanks        # 录制录入之前删除多余的空白
# }}}

# 按键绑定{{{
# default keymap
bindkey -s '\ee' 'vim\n'
bindkey '\eh' backward-char
bindkey '\el' forward-char
bindkey '\ej' down-line-or-history
bindkey '\ek' up-line-or-history
# bindkey '\eu' undo
bindkey '\eH' backward-word
bindkey '\eL' forward-word
bindkey '\eJ' beginning-of-line
bindkey '\eK' end-of-line

bindkey -s '\eo' 'cd ..\n'
bindkey -s ';;' 'ls\n'

bindkey '\e[1;3D' backward-word
bindkey '\e[1;3C' forward-word
bindkey '\e[1;3A' beginning-of-line
bindkey '\e[1;3B' end-of-line

bindkey '\ev' deer
# }}}

# 别名 {{{
alias pdf2htmlEX='sudo docker run -ti --rm -v `pwd`:/pdf bwits/pdf2htmlex pdf2htmlEX'
alias rm="trash"
alias f='find -name'
alias vi='vim'
alias minicom='minicom -w'
alias ncdu='baobab'
gdbtool () { emacs --eval "(gdb \"csky-abiv2-elf-gdb --annotate=3 -i=mi $*\")";}
# }}}

# 环境变量 {{{

export EDITOR=vim
export LESSCHARSET=utf-8
export FORCE_UNSAFE_CONFIGURE=1

export PATH=$PATH:/opt/gxtools/csky/3.8.12/bin
#export PATH=$PATH:/opt/gxtools/csky/2.8.07/bin
export PATH=$PATH:~/work/intelFPGA/17.1/quartus/bin
export PATH=$PATH:/opt/gxtools/jlink:/opt/gxtools/gdb-7.11/bin/:/opt/gxtools/DebugServerConsole/

export PATH=$PATH:/home/liyj/work/robotos/toolchains/csky/bin:/home/liyj/work/robotos/toolchains/arm/bin
export PATH=$PATH:/home/liyj/xtensa/XtDevTools/install/tools/RG-2017.8-linux/XtensaTools/bin

export STAGING_DIR=/home/liyj/work/robotos/toolchains/arm

export XTENSA_CORE=GXHifi4_170719A_G1708
export XTENSA_SYSTEM=/home/liyj/xtensa/XtDevTools/install/builds/RG-2017.8-linux/${XTENSA_CORE}/config
# }}}

alias svi='vim -u ~/.SpaceVim/vimrc'
alias snvi='nvim -u ~/.SpaceVim/vimrc'
alias lvi='vim -u ~/.vim_init/vim-init/init.vim'
alias lnvi='nvim -u ~/.vim_init/vim-init/init.vim'
alias pnvi='nvim -u ~/.vim_init/vim-init/init.vim'

#zprof
