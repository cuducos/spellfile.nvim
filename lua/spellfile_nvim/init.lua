local path = require("spellfile_nvim.path")

local M = {}

M.config = {
	url = "https://ftp.nluug.nl/pub/vim/runtime/spell",
	encoding = vim.o.encoding,
	rtp = vim.opt.rtp:get(),
}

M.done = {}

M.setup = function(opts)
	M.done = {}
	M.config = vim.tbl_extend("force", M.config, opts or {})
end

M.directory_choices = function()
	local options = {}
	for _, dir in ipairs(M.config.rtp) do
		local spell = dir .. "/spell"
		if vim.fn.isdirectory(spell) == 1 then
			table.insert(options, spell)
		end
	end
	return options
end

M.choose_directory = function()
	local options = M.directory_choices()
	if #options == 0 then
		vim.notify("No spell directory found in the runtimepath")
		return
	elseif #options == 1 then
		return options[1]
	end

	local prompt = {}
	for idx, dir in pairs(options) do
		table.insert(prompt, string.format("%d: %s", idx, dir))
	end
	local choice = vim.fn.inputlist(prompt)
	if choice <= 0 or choice > #options then
		return
	end

	return options[choice]
end

M.parse = function(lang)
	local code = lang:lower()

	local encoding = vim.bo.fileencoding
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

M.exists = function(file_name)
	for _, dir in pairs(M.directory_choices()) do
		if path.is_file(dir .. "/" .. file_name) then
			return true
		end
	end
	return false
end

M.download = function(data)
	local prompt = string.format("No spell file found for %s in %s. Download it? [y/N] ", data.lang, data.encoding)
	if vim.fn.input(prompt):lower() ~= "y" then
		return
	end

	local dir = M.choose_directory()
	if dir == nil then
		return
	end

	local url = M.config.url .. "/" .. data.file_name
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

	vim.notify(string.format("\nDownloading %s...", data.lang))
	vim.fn.system(cmd)
end

M.load_file = function(lang)
	local data = M.parse(lang)
	if M.exists(data.file_name) then
		return
	end

	for key, _ in pairs(M.done) do
		if key == data.file_name then
			vim.notify("Already tried this language before: " .. lang:lower())
			return
		end
	end

	M.download(data)
	M.done[data.file_name] = true
end

return M
