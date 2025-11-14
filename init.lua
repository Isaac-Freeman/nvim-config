-- ===============================
-- Basic Neovim Configuration (Lua)
-- ===============================

vim.g.mapleader = " "
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


-- Bootstrap lazy.nvim (this installs lazy.nvim if it doesn't exist yet)
local lazypath = vim.fn.stdpath('data')..'/site/pack/packer/start/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath
  })
end
vim.opt.rtp:prepend(lazypath)
-- Keep some lines visible when scrolling
vim.opt.scrolloff = 5

vim.opt.termguicolors = true
vim.cmd("syntax on")
vim.cmd("colorscheme desert")

--==============================
--TIDALCYCLES


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

  {'goerz/jupytext.vim'},
  {'Vigemus/iron.nvim'},
  { "tpope/vim-commentary" },
  { "tpope/vim-surround" },
})

vim.g.tidal_target = "terminal"       -- use a Neovim terminal for output
vim.g.tidal_default_dir = "~/Tidal/"  -- optional: where your Tidal files live
vim.g.tidal_autostart = 0             -- don’t start Tidal automatically
--TRY IRON CONFIG ON GITHUB
--
local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        -- Can be a table or a function that
        -- returns a table (see below)
        command = {"zsh"}
      },
      python = {
        command = { "python3" },  -- or { "ipython", "--no-autoindent" }
        format = common.bracketed_paste_python,
        block_dividers = { "# %%", "#%%" },
        env = {PYTHON_BASIC_REPL = "1"} --this is needed for python3.13 and up.
      }
    },
    -- set the file type of the newly created repl to ft
    -- bufnr is the buffer id of the REPL and ft is the filetype of the 
    -- language being used for the REPL. 
    repl_filetype = function(bufnr, ft)
      return ft
      -- or return a string name such as the following
      -- return "iron"
    end,
    -- Send selections to the DAP repl if an nvim-dap session is running.
    dap_integration = true,
    -- How the repl window will be displayed
    -- See below for more information
    
    repl_open_cmd = view.split.right(0.66),  -- 66% of the width on the right
    -- repl_open_cmd can also be an array-style table so that multiple 
    -- repl_open_commands can be given.
    -- When repl_open_cmd is given as a table, the first command given will
    -- be the command that `IronRepl` initially toggles.
    -- Moreover, when repl_open_cmd is a table, each key will automatically
    -- be available as a keymap (see `keymaps` below) with the names 
    -- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
    -- For example,
    -- 
    -- repl_open_cmd = {
    --   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
    --   view.split.rightbelow("%25")  -- cmd_2: open a repl below
    -- }

  },
  -- Iron doesn't set keymaps by default anymore.
  -- You can set them here or manually add keymaps to the functions in iron.core
  keymaps = {
    toggle_repl = "<space>rr", -- toggles the repl open and closed.
    -- If repl_open_command is a table as above, then the following keymaps are
    -- available
    -- toggle_repl_with_cmd_1 = "<space>rv",
    -- toggle_repl_with_cmd_2 = "<space>rh",
    restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
    send_motion = "<space>sc",
    visual_send = "<space>sc",
    send_file = "<space>sf",
    send_line = "<space>sl",
    send_paragraph = "<space>sp",
    send_until_cursor = "<space>su",
    send_mark = "<space>sm",
    send_code_block = "<space>sb",
    send_code_block_and_move = "<space>sn",
    mark_motion = "<space>mc",
    mark_visual = "<space>mc",
    remove_mark = "<space>md",
    cr = "<space>s<cr>",
    interrupt = "<space>s<space>",
    exit = "<space>sq",
    clear = "<space>cl",
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

-- Wrap Iron send safely to auto-scroll REPL
local iron = require("iron.core")
local old_send = iron.send

iron.send = function(repls, lines)
  -- call original send
  old_send(repls, lines)

  -- schedule safe auto-scroll
  vim.schedule(function()
    if repls and repls.last_bufnr and vim.api.nvim_buf_is_loaded(repls.last_bufnr) then
      local repl_win = vim.fn.bufwinid(repls.last_bufnr)
      if repl_win ~= -1 then
        vim.api.nvim_win_call(repl_win, function()
          vim.cmd("normal! G")  -- scroll to bottom
        end)
      end
    end
  end)
end
-- --------------------
-- Large scrollback
-- --------------------
vim.opt.scrollback = 10000

-- --------------------
-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
-- ===============================
-- End of minimal Lua config
-- ===============================

