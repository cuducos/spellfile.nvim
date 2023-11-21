-- TODO: wrap in a autocmd SpellFileMissing

local M = {}
M.config = { url = "https://ftp.nluug.nl/pub/vim/runtime/spell" }
M.done = {}

M.setup = function(opts)
	M.config = vim.tbl_extend("force", M.config, opts or {})
	M.done = {}
end

M.load_file = function(lang)
	local code = lang:lower()
	for key, _ in pairs(M.done) do
		if key == code then
			vim.notify("Already tried this language before: " .. code)
			return
		end
	end

	M.done[code] = true
end

M.directory_choices = function()
	local options = {}
	for _, dir in ipairs(vim.opt.rtp:get()) do
		local spell = dir .. "/spell"
		if vim.fn.isdirectory(spell) == 1 then
			table.insert(options, spell)
		end
	end
	return options
end

return M
