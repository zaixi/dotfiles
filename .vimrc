if (has("nvim"))
    let nvim_init_lua=expand('$HOME/.config/nvim/init.lua')
    if !filereadable(nvim_init_lua)
        echo "Installing NvChad ..."
        echo ""
        silent !git clone https://github.com/NvChad/NvChad $HOME/.config/nvim --depth 1
        silent !git clone https://github.com/zaixi/nvchad_config $HOME/.config/nvim/lua/custom --depth 1
    endif
    lua $HOME/.config/nvim/init.lua
else
    let vim_init_readme=expand('$HOME/.vim-init/README.md')
    if !filereadable(vim_init_readme)
        echo "Installing vim-init ..."
        echo ""
        silent !git clone https://github.com/zaixi/vim-init $HOME/.vim-init --depth 1
    endif
    source $HOME/.vim-init/main.vim
endif
