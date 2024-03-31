--------------
-- SETTINGS --
--------------

-- Unbind previous and set leader key to spacebar
-- vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
-- vim.g.mapleader = " "

-- Disable folding completely
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 99

-- Disable wrapping
vim.opt.wrap = false

-- Always draw sign column
-- vim.opt.signcolumn = 'yes'

-- Line numbers
vim.opt.number = true

-- Persistent undo
vim.opt.undofile = true

-- Tabs are 4 spaces
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- No bell
vim.opt.vb = true

-- No extra files file
vim.opt.swapfile = false
vim.opt.backup = false

-- Enable mouse selection
vim.opt.mouse = 'a'

-- Smarter diff algorithm
-- https://vimways.org/2018/the-power-of-diff/
-- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
-- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')

-- Column at 80 chars
vim.opt.colorcolumn = '80'

-- Jump to last edit position on opening file
vim.api.nvim_create_autocmd(
	'BufReadPost',
	{
		pattern = '*',
		callback = function(ev)
			if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
				-- except for in git commit messages
				-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
				if not vim.fn.expand('%:p'):find('.git', 1, true) then
					vim.cmd('exe "normal! g\'\\""')
				end
			end
		end
	}
)

-------------
-- PLUGINS --
-------------

-- -- Add Lazy plugin manager
-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not (vim.uv or vim.loop).fs_stat(lazypath) then
--   vim.fn.system({
--     "git",
--     "clone",
--     "--filter=blob:none",
--     "https://github.com/folke/lazy.nvim.git",
--     "--branch=stable", -- latest stable release
--     lazypath,
--   })
-- end
-- vim.opt.rtp:prepend(lazypath)

-- -- Add plugins
-- require("lazy").setup({
--     -- nice bar at the bottom
-- 	{
-- 		'itchyny/lightline.vim',
-- 		lazy = false, -- also load at start since it's UI
-- 		config = function()
-- 			-- no need to also show mode in cmd line when we have bar
-- 			vim.o.showmode = false
-- 			vim.g.lightline = {
-- 				active = {
-- 					left = {
-- 						{ 'mode', 'paste' },
-- 						{ 'readonly', 'filename', 'modified' },
-- 					},
-- 					right = {
-- 						{ 'lineinfo' },
-- 						{ 'percent' },
-- 						{ 'fileencoding', 'filetype' },
-- 					},
-- 				},
-- 				component_function = {
-- 					filename = 'LightlineFilename',
-- 				},
-- 			}
-- 
-- 			function LightlineFilenameInLua(opts)
-- 				if vim.fn.expand('%:t') == '' then
-- 					return '[No Name]'
-- 				else
-- 					return vim.fn.getreg('%')
-- 				end
-- 			end
-- 
-- 			-- https://github.com/itchyny/lightline.vim/issues/657
-- 			vim.api.nvim_exec(
-- 				[[
-- 				function! g:LightlineFilename()
-- 					return v:lua.LightlineFilenameInLua()
-- 				endfunction
-- 				]],
-- 				true
-- 			)
-- 		end
-- 	},
--     -- auto-cd to root of git project
-- 	{
-- 		'notjedi/nvim-rooter.lua',
-- 		config = function()
-- 			require('nvim-rooter').setup()
-- 		end
-- 	},
--     -- fzf support for C-p
-- 	{
-- 		'junegunn/fzf.vim',
-- 		dependencies = {
-- 			{ 'junegunn/fzf', dir = '~/.fzf', build = './install --all' },
-- 		},
-- 		config = function()
-- 			-- stop putting a giant window over my editor
-- 			vim.g.fzf_layout = { down = '~20%' }
-- 			-- when using :Files, pass the file list through
-- 			--
-- 			--   https://github.com/jonhoo/proximity-sort
-- 			--
-- 			-- to prefer files closer to the current file.
-- 			function list_cmd()
--                 return 'fd --type file --follow'
-- 			end
-- 			vim.api.nvim_create_user_command('Files', function(arg)
--                 vim.fn['fzf#vim#files'](arg.qargs, { source = list_cmd(), options = '--tiebreak=index' }, arg.bang)
--                 end, { bang = true, nargs = '?', complete = "dir" })
-- 		end
-- 	},
-- 
--     -- LSP
-- 	{
-- 		'neovim/nvim-lspconfig',
-- 		config = function()
-- 			-- Setup language servers.
-- 			local lspconfig = require('lspconfig')
-- 
-- 			-- Rust
-- 			lspconfig.rust_analyzer.setup {
-- 				-- Server-specific settings. See `:help lspconfig-setup`
-- 				settings = {
-- 					["rust-analyzer"] = {
-- 						cargo = {
-- 							allFeatures = true,
-- 						},
-- 						imports = {
-- 							group = {
-- 								enable = false,
-- 							},
-- 						},
-- 						completion = {
-- 							postfix = {
-- 								enable = false,
-- 							},
-- 						},
-- 					},
-- 				},
-- 			}
-- 
-- 			-- Global mappings.
-- 			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- 			--vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- 			--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
-- 			vim.keymap.set('n', '<C-S-n>', vim.diagnostic.goto_prev)
-- 			vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_next)
-- 
-- 			-- Use LspAttach autocommand to only map the following keys
-- 			-- after the language server attaches to the current buffer
-- 			vim.api.nvim_create_autocmd('LspAttach', {
-- 				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
-- 				callback = function(ev)
-- 					-- Enable completion triggered by <c-x><c-o>
-- 					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
-- 
-- 					-- Buffer local mappings.
-- 					-- See `:help vim.lsp.*` for documentation on any of the below functions
-- 					local opts = { buffer = ev.buf }
-- 					vim.keymap.set('n', '<F11>', vim.lsp.buf.declaration, opts)
-- 					vim.keymap.set('n', '<F12>', vim.lsp.buf.definition, opts)
--                     --[[
-- 					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
-- 					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
-- 					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
-- 					vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
-- 					vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
-- 					vim.keymap.set('n', '<leader>wl', function()
-- 						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- 					end, opts)
-- 					--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
-- 					vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
-- 					vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
-- 					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
-- 					vim.keymap.set('n', '<leader>f', function()
-- 						vim.lsp.buf.format { async = true }
-- 					end, opts)
--                     ]]--
-- 
-- 					local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 
-- 					-- When https://neovim.io/doc/user/lsp.html#lsp-inlay_hint stabilizes
-- 					-- *and* there's some way to make it only apply to the current line.
-- 					-- if client.server_capabilities.inlayHintProvider then
-- 					--     vim.lsp.inlay_hint(ev.buf, true)
-- 					-- end
-- 
-- 					-- None of this semantics tokens business.
-- 					-- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
-- 					client.server_capabilities.semanticTokensProvider = nil
-- 				end,
-- 			})
-- 		end
-- 	},
-- 
--     -- toml
-- 	'cespare/vim-toml',
-- 
--     -- rust
-- 	{
--         enable = false,
-- 		'rust-lang/rust.vim',
-- 		ft = { "rust" },
--         -- config = function()
-- 		-- 	vim.g.rustfmt_autosave = 1
-- 		-- 	vim.g.rustfmt_emit_files = 1
-- 		-- 	vim.g.rustfmt_fail_silently = 0
-- 		-- 	vim.g.rust_clip_command = 'wl-copy'
-- 		-- end
-- 	},
-- })


-------------
-- HOTKEYS --
-------------
-- vim.keymap.set('', '<C-p>', '<cmd>Files<cr>')

