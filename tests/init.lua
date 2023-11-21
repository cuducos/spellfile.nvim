-- install spellfile.nvim
vim.opt.rtp:append(vim.fn.expand("."))
vim.cmd("runtime plugin/spellfile.nvim")

-- install plenary to run test
local dir = os.getenv("PLENARY_DIR") or "/tmp/plenary.nvim"
if vim.fn.isdirectory(dir) == 0 then
	print(vim.fn.system({ "git", "clone", "https://github.com/nvim-lua/plenary.nvim", dir }))
end
vim.opt.rtp:append(dir)
vim.cmd("runtime plugin/plenary.nvim")
require("plenary.busted")
