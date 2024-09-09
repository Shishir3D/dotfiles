call plug#begin('~/.local/share/nvim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }  " Install Dracula theme
Plug 'nvim-tree/nvim-tree.lua'

" Mason
Plug 'williamboman/mason.nvim'
" Mason LSPConfig
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'
" Optional | LSPConfig for additional configurations
Plug 'neovim/nvim-lspconfig'

" Auto-completion plugin
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'    " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'      " Buffer completions
Plug 'hrsh7th/cmp-path'        " File path completions
Plug 'hrsh7th/cmp-cmdline'     " Command line completions
Plug 'hrsh7th/cmp-vsnip'       " Snippet completions
Plug 'hrsh7th/vim-vsnip'       " Snippet engine

" Formatter plugin
Plug 'mhartington/formatter.nvim'

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

nnoremap <C-e> :NvimTreeToggle<CR>

" Set tab width to 4 spaces
set tabstop=4
" Use 4 spaces when pressing Tab
set shiftwidth=4

" Lua config starts

lua require('nvim-tree').setup()

lua << EOF
-- Mason and LSP setup
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 
	  "pyright",
	  "html",
	  "cssls",
	  "ts_ls"
	}, -- You can list other servers here
})

-- Install tools like formatters or linters using mason-tool-installer
require('mason-tool-installer').setup({
  ensure_installed = {
    "black",     -- Python formatter
    "prettier",  -- JavaScript/TypeScript formatter
  },
  auto_update = false,
  run_on_start = true,
})

-- Import formatter.nvim
local formatter = require('formatter')

-- Formatter configurations
formatter.setup({
  filetype = {
    python = {
      function()
        return {
          exe = "black",
          args = { "-" },
          stdin = true
        }
      end
    },
    javascript = {
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
          stdin = true
        }
      end
    },
    -- Add other filetype configurations here
  }
})

-- Format on save
vim.cmd [[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.py,*.js,*.ts,*.jsx,*.tsx FormatWrite
  augroup END
]]

-- Enable autocompletion for Python with Pyright
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Python LSP setup
lspconfig.pyright.setup{
  capabilities = capabilities,
}

-- HTML LSP setup
lspconfig.html.setup{
  capabilities = capabilities,
}

-- CSS LSP setup
lspconfig.cssls.setup{
  capabilities = capabilities,
}

-- JavaScript/TypeScript LSP setup
lspconfig.ts_ls.setup{
  capabilities = capabilities,
}

-- Set up nvim-cmp for autocompletion
local cmp = require'cmp'

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
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    -- Tab mapping for nvim-cmp
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn  == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- Fallback to normal behavior (e.g., indent)
      end
    end, { "i", "s" }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },  -- LSP source for autocompletion
    { name = 'vsnip' },     -- Snippet source
  }, {
    { name = 'buffer' },    -- Buffer source
  })
})
EOF
