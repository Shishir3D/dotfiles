call plug#begin('~/.local/share/nvim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }  " Theme
Plug 'nvim-tree/nvim-tree.lua'

" Mason & LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'
Plug 'neovim/nvim-lspconfig'

" Auto-completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Auto-pairs (updated plugin)
Plug 'windwp/nvim-autopairs'

" Formatter
Plug 'mhartington/formatter.nvim'

" Tmux navigation
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" Basic settings
syntax enable
set background=dark
set clipboard=unnamedplus
set relativenumber
set nohlsearch
set tabstop=4
set shiftwidth=4
set nowrap

" Dracula transparent background
augroup TransparentBackground
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=none guibg=none
  autocmd ColorScheme * highlight NonText ctermbg=none guibg=none
augroup END

colorscheme dracula

" Keybindings
nnoremap <C-e> :NvimTreeToggle<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
inoremap jj <Esc>

" Lua plugin configs
lua require('nvim-tree').setup()

lua << EOF
-- Mason and LSP setup
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    "pyright",
    "html",
    "cssls",
    "ts_ls",
    "clangd",
  },
})

require('mason-tool-installer').setup({
  ensure_installed = {
    "black",
    "prettier",
  },
  auto_update = false,
  run_on_start = true,
})

-- Formatter config
require("formatter").setup({
  filetype = {
    python = {
      function()
        return {
          exe = "black",
          args = { "-" },
          stdin = true,
        }
      end
    },
    javascript = {
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end
    },
    html = {
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end
    },
  }
})

vim.cmd [[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.py,*.js,*.ts,*.jsx,*.tsx,*.html FormatWrite
  augroup END
]]

-- LSP setup
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.clangd.setup({ capabilities = capabilities })
lspconfig.pyright.setup({ capabilities = capabilities })
lspconfig.html.setup({ capabilities = capabilities })
lspconfig.cssls.setup({ capabilities = capabilities })
lspconfig.ts_ls.setup({ capabilities = capabilities })

-- nvim-cmp setup
local cmp = require("cmp")
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Autopairs setup
require("nvim-autopairs").setup {}

-- Integration with nvim-cmp
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
EOF
