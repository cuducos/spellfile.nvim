local path = require("spellfile_nvim.path")

local M = {}

M.config = {
	url = "https://ftp.nluug.nl/pub/vim/runtime/spell",
	encoding = "utf-8",
}

M.done = {}

M.setup = function(opts)
	M.config = vim.tbl_extend("force", M.config, opts or {})
	M.done = {}
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

M.file_name = function(lang)
	local encoding = vim.bo.fileencoding or vim.o.encoding
	if encoding == "" then
		encoding = M.config.encoding
	end
	if encoding == "iso-8859-1" then
		encoding = "latin1"
	end
	return lang:lower() .. "." .. encoding .. ".spl"
end

M.exists = function(lang)
	local name = M.file_name(lang)
	for _, dir in pairs(M.directory_choices()) do
		if path.is_file(dir .. "/" .. name) then
			return true
		end
	end
	return false
end

M.load_file = function(lang)
	local file_name = M.file_name(lang)
	for key, _ in pairs(M.done) do
		if key == file_name then
			vim.notify("Already tried this language before: " .. lang:lower())
			return
		end
	end

	M.done[file_name] = true
end

-- TODO: wrap in a autocmd SpellFileMissing
return M
