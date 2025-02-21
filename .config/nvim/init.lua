-- space is leader key
vim.g.mapleader = " "

-- sensible behavior of buffers
vim.opt.hidden = true

-- encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileformats = "unix"

-- command completion
vim.opt.wildmode = "longest,list"
vim.opt.history = 100

-- whitespace and indentation
vim.opt.autoindent = true
vim.opt.backspace = "indent,eol,start"
vim.opt.expandtab = true
vim.opt.formatoptions:remove("t")
vim.opt.smartindent = false
vim.opt.startofline = false
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.textwidth = 79

-- don't display long lines as wrapped; instead horizontally scroll viewport
vim.opt.wrap = false
vim.opt.sidescroll = 1

-- search behavior
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- display diffs with vertical split
vim.opt.diffopt = "filler,vertical"

-- show useful information
vim.opt.colorcolumn = "+1"
vim.opt.cursorline = true
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.listchars = { tab = "├─┤", trail = "·" }
vim.opt.modeline = true
vim.opt.number = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.showmode = true

-- netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
-- start with dotfiles hidden
vim.g.netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"

-- bootstrap lazy.nvim
do
    local local_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.uv.fs_stat(local_path) then
        local git_url = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "--branch=stable",
            git_url,
            local_path,
        })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone " .. git_url .. "\n" .. out, "ErrorMsg" },
                { "Press any key to exit", "MoreMsg" },
            }, true, {})
        end
    end
    vim.opt.rtp:prepend(local_path)
end

plugins = {
    {
        url = "https://github.com/altercation/vim-colors-solarized.git",
        branch = "master",
        init = function()
            vim.o.termguicolors = false
            vim.cmd.colorscheme("solarized")
            vim.opt.background = "dark"
        end,
    },
    {
        url = "https://github.com/nvim-lualine/lualine.nvim.git",
        branch = "master",
        init = function()
            require("lualine").setup({
                options = {
                    icons_enabled = false,
                    section_separators = "",
                    component_separators = "│",
                },
            })
        end,
    },
    {
        url = "https://github.com/nvim-treesitter/nvim-treesitter.git",
        tag = "v0.10.0",
        build = ":TSUpdate",
    },
    {
        url = "https://github.com/lewis6991/gitsigns.nvim.git",
        tag = "v2.0.0",
        init = function()
            require("gitsigns").setup()
        end,
    },
    {
        url = "https://github.com/stevearc/conform.nvim.git",
        tag = "v9.1.0",
        init = function()
            require("conform").setup({
                format_on_save = {},
                formatters_by_ft = {
                    ["css"] = { "oxfmt" },
                    ["haskell"] = { "ormolu" },
                    ["html"] = { "oxfmt" },
                    ["javascript"] = { "oxfmt" },
                    ["json"] = { "oxfmt" },
                    ["lua"] = { "stylua" },
                    ["markdown"] = { "oxfmt" },
                    ["python"] = { "ruff" },
                    ["rust"] = { "rustfmt" },
                    ["sh"] = { "shfmt" },
                    ["yaml"] = { "oxfmt" },
                },
                formatters = {
                    oxfmt = {
                        command = "oxfmt",
                        args = { "$FILENAME" },
                        stdin = false,
                    },
                    shfmt = {
                        prepend_args = { "-i", "4", "-ci", "-sr" },
                    },
                },
            })
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
            vim.keymap.set("n", "<leader>c", function()
                require("conform").format()
            end, {
                desc = "format with conform.nvim",
            })
        end,
    },
    {
        url = "https://github.com/nvim-telescope/telescope.nvim.git",
        tag = "0.2.1",
        init = function()
            require("telescope").setup()
            vim.keymap.set("n", "<leader>f", function()
                require("telescope.builtin").find_files()
            end, {
                desc = "find files with telescope.nvim",
            })
            vim.keymap.set("n", "<leader>g", function()
                require("telescope.builtin").live_grep()
            end, {
                desc = "ripgrep with telescope.nvim",
            })
        end,
    },
}
require("lazy").setup({ spec = plugins, defaults = { lazy = false } })
