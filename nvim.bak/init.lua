local o = vim.opt

o.fileformats = { "unix","dos", "mac" }

-- Clipboard integration
o.clipboard = "unnamedplus"

-- Autocomplete behavior
o.completeopt = { "noinsert", "menuone", "noselect" }

-- Highlight current line
o.cursorline = true

-- Hide unused buffers
o.hidden = true

-- Auto-indent new lines
o.autoindent = true

-- Incremental command previews
o.inccommand = "split"

-- Mouse support
o.mouse = "a"

-- Show line numbers
o.number = true
o.relativenumber = true

-- Split window behavior
o.splitbelow = true
o.splitright = true

-- Display file title
o.title = true

-- Advanced completion menu
o.wildmenu = true

-- Column marker for good coding style
o.colorcolumn = "80"

-- Syntax highlighting and filetype-based indentation
vim.cmd([[filetype plugin indent on]])
vim.cmd([[syntax on]])

-- Enable spell checking
o.spell = true

-- Improve scrolling speed
o.ttyfast = true

-- Plugins setup using vim-plug
local Plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.stdpath('data') .. '/plugged')

Plug('github/copilot.vim')
Plug('morhetz/gruvbox')
Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')
Plug('ryanoasis/vim-devicons')
Plug('scrooloose/nerdtree')
Plug('scrooloose/nerdcommenter')
Plug('sheerun/vim-polyglot')
Plug('jiangmiao/auto-pairs')
Plug('neoclide/coc.nvim', {branch = 'release'})
Plug('tpope/vim-fugitive')

vim.call('plug#end')

-- Set colorscheme
vim.cmd([[colorscheme gruvbox]])

-- Plugin-specific configurations
vim.g.bargreybars_auto = 0
vim.g.airline_solarized_bg = 'dark'
vim.g.airline_powerline_fonts = 1
vim.g['airline#extension#tabline#enable'] = 1
vim.g['airline#extension#tabline#left_sep'] = ' '
vim.g['airline#extension#tabline#left_alt_sep'] = '|'
vim.g['airline#extension#tabline#formatter'] = 'unique_tail'
vim.g.NERDTreeQuitOnOpen = 1

