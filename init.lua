vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec =
  {
    {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true

      vim.keymap.set({ "n", "x" }, "<C-a>", function() 
        require("opencode").ask("@this: ", { submit = true }) 
      end, { desc = "Ask opencode…" })
      
      vim.keymap.set({ "n", "x" }, "<C-x>", function() 
        require("opencode").select() 
      end, { desc = "Execute opencode action…" })
      
      vim.keymap.set({ "n", "t" }, "<C-.>", function() 
        require("opencode").toggle() 
      end, { desc = "Toggle opencode" })

      vim.keymap.set({ "n", "x" }, "go", function() 
        return require("opencode").operator("@this ") 
      end, { desc = "Add range to opencode", expr = true })
      
      vim.keymap.set("n", "goo", function() 
        return require("opencode").operator("@this ") .. "_" 
      end, { desc = "Add line to opencode", expr = true })

      vim.keymap.set("n", "<S-C-u>", function() 
        require("opencode").command("session.half.page.up") 
      end, { desc = "Scroll opencode up" })
      
      vim.keymap.set("n", "<S-C-d>", function() 
        require("opencode").command("session.half.page.down") 
      end, { desc = "Scroll opencode down" })

      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
      end,
    },
    {
      "catppuccin/nvim", 
      name = "catppuccin", 
      priority = 1000 
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { 
        "nvim-telescope/telescope.nvim", 
        "nvim-lua/plenary.nvim" 
      }
    },
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate',
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
      },
      lazy = false, -- neo-tree will lazily load itself
    },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- Activate plugins
local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if status_ok then
  treesitter.setup({
    ensure_installed = {
      "lua", "vim", "vimdoc", "query", "markdown", 
      "go", "gomod", "gosum", 
      "html", "java", "typescript", "javascript", 
      "xml", "json", "yaml"
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
  })
end


require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
local telescope = require('telescope.builtin')

--Custom Keymappings
--Normal mode
vim.keymap.set('n', '<leader>ft', ':Neotree filesystem reveal left<CR>', { desc = 'Open filetree'})
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files'})
vim.keymap.set('n', '<C-f>', telescope.live_grep, { desc = 'Telescope live grep'})
vim.keymap.set('n', '<leader>gg', telescope.grep_string, {desc = 'Telescope grep string'})
vim.keymap.set('n', '<leader>t', '<C-w>s<C-w>j:resize -14<CR>:terminal<CR>', { desc = 'Open terminal'})
vim.keymap.set('n', '<leader>N', '<C-w>v', { desc = 'Open new window vertically'})
vim.keymap.set('n', '<leader>C', '<C-w>c', { desc = 'Close window'})
vim.keymap.set('n', '<C-Right>', '<C-w>l', { desc = 'Move to right window'})
vim.keymap.set('n', '<C-Left>', '<C-w>h', {desc = 'Move to left window'})
vim.keymap.set('n', '<C-Up>', '<C-w>k', { desc = 'Move to upper window'})
vim.keymap.set('n', '<C-Down>', '<C-w>j', { desc = 'Move to lower window'})
vim.keymap.set('n', '<A-Up>', ':resize +2<CR>', { desc = 'Increase height'})
vim.keymap.set('n', '<A-Down>', ':resize -2<CR>', { desc = 'Decrease height'})
vim.keymap.set('n', '<A-Right>', ':vertical resize -2<CR>', { desc = 'Increase width'})
vim.keymap.set('n', '<A-Left>', ':vertical resize +2<CR>', { desc = 'Decrease width'})
vim.keymap.set('n','<Tab>', '>>', {desc = "Indent"})
vim.keymap.set('n','<S-Tab>','<<', {desc = "Indent"})

--Insert mode
vim.keymap.set('i', '<S-Tab>', '<C-d>', {desc = "Unindent"})
vim.keymap.set('i', '<C-z>', '<C-o>u', {desc = "Undo"})
vim.keymap.set('i', '<C-d>', '<C-o>dd', {desc = "Delete line"})

--Visual mode
vim.keymap.set('v', '<S-Tab>', '<gv', {desc = "Unindent and reselect"})
vim.keymap.set('v', '<Tab>', '>gv', {desc = "Indent and reselect"})
vim.keymap.set('v', '<C-c>', '"+y', {desc = "Copy to clipboard"})


--Terminal mode,
vim.keymap.set('t', '<Esc>','<C-\\><C-n>', { desc = 'Close terminal' })

