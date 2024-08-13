" located at ~/.config/nvim/init.vim
call plug#begin('~/.local/share/nvim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }  " Install Dracula theme
Plug 'nvim-tree/nvim-tree.lua'

" Mason
Plug 'williamboman/mason.nvim'
" Mason LSPConfig
Plug 'williamboman/mason-lspconfig.nvim'
" Optional | LSPConfig for additional configurations
Plug 'neovim/nvim-lspconfig'

call plug#end()

syntax enable             " Enables syntax highlighting
set background=dark       " Dracula is a dark theme

augroup TransparentBackground
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=none guibg=none
  autocmd ColorScheme * highlight NonText ctermbg=none guibg=none
augroup END

colorscheme dracula
set relativenumber

" Load Lua configurations
lua require('nvim-tree').setup()

nnoremap <C-e> :NvimTreeToggle<CR>

lua << EOF
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { "pyright" }, -- You can list other servers here
})

local lspconfig = require('lspconfig')

-- Setup LSP for Python
lspconfig.pyright.setup{}
EOF
