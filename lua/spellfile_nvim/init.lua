-- TODO: wrap in a autocmd SpellFileMissing

-- public API
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

return M
