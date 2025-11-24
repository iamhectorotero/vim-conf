" Set errorbells off. In later versions of Vim it can be done with 'set belloff=all'
" To disable bells at system level as well, add:
" - BASH: 'set bell-style visible' to .inputrc
" - ZSH: 'unsetopt BEEP' to .zshrc
set vb t_vb=

" Syntax highlighting
syntax on

" Tabs as spaces
set tabstop=4
set shiftwidth=4
set expandtab

"EOL and tabs visible
set listchars=eol:¬,tab:>.
set list 

"Set hybrid line numbers
set nu rnu

" Vertical column for line width
highlight ColorColumn ctermbg=238
set colorcolumn=120
" Set Black's default linelength

" Allow backspacing over indents, line breaks and before the start of current insert.
set backspace=indent,eol,start

" Show with a horizontal line where the cursor currently is
set cursorline
" set cursorlineopt=number
"
" Open markdown files with Chrome.
autocmd BufEnter *.md exe 'noremap <F5> :!open -a "Firefox.app" %:p<CR>'

call plug#begin()

Plug 'mason-org/mason.nvim' " To manage external editor tools like lsps, linter and formatters

Plug 'neovim/nvim-lspconfig' " A collection of LSP server configurations (required for mason-lspconfig)
Plug 'mason-org/mason-lspconfig.nvim' " Installs and enables LSP servers

Plug 'stevearc/conform.nvim' "For formatters
Plug 'mfussenegger/nvim-lint' " For linters

Plug 'github/copilot.vim' " For in-line completion

" For AI-chat mode
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'

" For fuzzy finding. Depends on plenary.nvim (Plug it) and ripgrep (brew it)
Plug 'nvim-telescope/telescope.nvim'

" color scheme
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' } " For running jupyter-like cells

call plug#end()

lua << EOF
-- Set leader **before any keymaps** that use <leader>
vim.g.mapleader = " "

-- vim.lsp.set_log_level("debug") -- if debugging is necessary

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Telescope help tags' })

-- setup formatters with conform (requires the formatters being installed in the env)
require("conform").setup({
    notify_no_formatters = true,
    notify_on_error = true,
    -- log_level = vim.log.levels.DEBUG, -- if debugging is necessary
    format_on_save = {
        timeout_ms = 2000,
    },
    formatters_by_ft = {
        python = {'black', 'reorder-python-imports'},
        sql = {'sqlfluff'},
    },
    formatters = {
        reorder_python_imports = {
            command = "reorder-python-imports",
            stdin = false, -- necessary so that the file is not overwritten with the stdout messages
        },
        sqlfluff = {
            command = "sqlfluff",
            args = {"fix", "--dialect=snowflake", "$FILENAME"},
            stdin = false, -- necessary so that the file is not overwritten with the stdout messages
        },
    },
})

-- Setup linters with nvim lint (requires linters being installed in the env)
require('lint').linters_by_ft = {
    python = {'mypy', 'flake8'}
}
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePre" }, { -- they will run on opening a file and on save
    callback = function()
        require("lint").try_lint()
    end,
})

require('mason').setup()
require("mason-lspconfig").setup { ensure_installed = { 'pylsp' }, }

vim.lsp.config('pylsp', {
    on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        -- Buffer local keymaps (only active when LSP is attached to a buffer)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- go to definition
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- show all references
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show dosctring / method definition
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- code action (e.g. lsp reformat)
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts) -- Expand error or warning message (e.g. margin E)
    end,

    settings = {
        pylsp = {
            plugins = {
                -- Ideally I would just take black and mypy as a plugin, but enabled = true doesn't work
                -- even if I have them python-lsp-black and pylsp_mypy installed in the venv
                black = { enabled = false }, -- doesn't work :(
                pylsp_mypy = { enabled = false }, -- doesn't work :(
                mypy = { enabled = false }, -- doesn't work :(
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                flake8 = { enabled = false },
                pylint = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
            },
        },
    },

})

local chat = require("CopilotChat")
chat.setup()
-- Make sure that CopilotChat and Copilot don't use the same keymaps
vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
vim.keymap.set("n", "<leader>aa", chat.toggle)

-- Set color scheme
vim.cmd.colorscheme "catppuccin"

EOF

