-- ===============================
-- Basic Neovim Configuration (Lua)
-- ===============================

-- Use UTF-8 everywhere
vim.opt.encoding = "utf-8"

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse support
vim.opt.mouse = "a"

-- Enable syntax highlighting
vim.cmd("syntax on")

-- Detect filetypes and apply indentation
vim.cmd("filetype plugin indent on")

-- Tabs and indentation
vim.opt.tabstop = 4        -- Display width of a tab
vim.opt.shiftwidth = 4     -- Indent width
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.smartindent = true -- Auto-indent new lines

-- Searching
vim.opt.ignorecase = true  -- Ignore case in searches...
vim.opt.smartcase = true   -- ...unless search has capitals
vim.opt.hlsearch = true    -- Highlight search results
vim.opt.incsearch = true   -- Search as you type

-- Line wrapping
vim.opt.wrap = false

-- Clipboard (use system clipboard)
vim.opt.clipboard = "unnamedplus"

-- Appearance
vim.opt.termguicolors = true -- True color support
vim.opt.cursorline = true    -- Highlight current line

-- Disable swap and backup files (optional)
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Show command in bottom right
vim.opt.showcmd = true

-- Keep some lines visible when scrolling
vim.opt.scrolloff = 5

vim.opt.termguicolors = true
vim.cmd("syntax on")
vim.cmd("colorscheme desert")

--==============================
--TIDALCYCLES

vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data").. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)


--Plug List
require("lazy").setup({
    "nvim-lua/plenary.nvim",

  { "neovimhaskell/haskell-vim" },
  { "tidalcycles/vim-tidal" },

  { "tpope/vim-commentary" },
  { "tpope/vim-surround" },
})

vim.g.tidal_target = "terminal"       -- use a Neovim terminal for output
vim.g.tidal_default_dir = "~/Tidal/"  -- optional: where your Tidal files live
vim.g.tidal_autostart = 0             -- don’t start Tidal automatically
-- ===============================
-- End of minimal Lua config
-- ===============================

