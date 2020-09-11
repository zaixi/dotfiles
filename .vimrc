let vim_init_readme=expand('$HOME/.vim-init/README.md')
if !filereadable(vim_init_readme)
    echo "Installing vim-init ..."
    echo ""
    silent !git clone https://github.com/zaixi/vim-init $HOME/.vim-init --depth 1
endif
source $HOME/.vim-init/main.vim
