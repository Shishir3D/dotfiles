" located at ~/.config/nvim/init.vim
call plug#begin('~/.local/share/nvim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }  " Install Dracula theme
Plug 'nvim-tree/nvim-tree.lua'

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

" Map NERDTreeToggle to the F2 key
lua require('nvim-tree').setup()
nnoremap <C-e> :NvimTreeToggle<CR>
