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

M.parse = function(lang)
	local code = lang:lower()

	local encoding = vim.bo.fileencoding or vim.o.encoding
	if encoding == "" then
		encoding = M.config.encoding
	end
	if encoding == "iso-8859-1" then
		encoding = "latin1"
	end

	return {
		file_name = string.format("%s.%s.spl", code, encoding),
		lang = code,
		encoding = encoding,
	}
end

M.exists = function(lang)
	local name = M.parse(lang).file_name
	for _, dir in pairs(M.directory_choices()) do
		if path.is_file(dir .. "/" .. name) then
			return true
		end
	end
	return false
end

M.load_file = function(lang)
	local file_name = M.parse(lang).file_name
	for key, _ in pairs(M.done) do
		if key == file_name then
			vim.notify("Already tried this language before: " .. lang:lower())
			return
		end
	end

	M.done[file_name] = true
end

M.download = function(lang, should_confirm)
	local data = M.parse(lang)
	if should_confirm == true then
		local prompt = string.format("No spell file found for %s in %s. Download it? [y/N] ", data.lang, data.encoding)
		if vim.fn.input(prompt):lower() ~= "y" then
			return
		end
	end

	local url = M.config.url .. "/" .. data.file_name
	local dir = M.directory_choices()[1]
	local pth = dir .. "/" .. data.file_name

	local cmd = ""
	if vim.fn.executable("curl") == 1 then
		cmd = string.format("curl -fLo %s %s", pth, url)
	elseif vim.fn.executable("wget") == 1 then
		cmd = string.format("wget -O %s %s", pth, url)
	else
		vim.notify("No curl or wget found. Please install one of them.")
		return
	end

	vim.notify("Downloading " .. lang:lower() .. "...")
	vim.fn.system(cmd)
end

-- TODO: wrap in a autocmd SpellFileMissing
return M
