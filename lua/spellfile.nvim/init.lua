-- TODO: wrap in a autocmd SpellFileMissing

-- defaults
local config = { url = "https://ftp.nluug.nl/pub/vim/runtime/spell" }

-- public API
local M

M.setup = function(opts)
	if opts ~= nil then
		for key, _ in pairs(config) do
			if opts[key] ~= nil then
				M.config[key] = opts[key]
			else
				M.config[key] = config[key]
			end
		end
	end
end

M.config = {}
M.setup()

return M

-- original spellfile.vim for reference

-- -- Vim script to download a missing spell file

-- vim.g.spellfile_URL = vim.g.spellfile_URL or 'https://ftp.nluug.nl/pub/vim/runtime/spell'
-- local spellfile_URL = ''

-- -- This function is used for the spellfile plugin.
-- local function LoadFile(lang)
--   -- Check for sandbox/modeline. #11359
--   pcall(vim.cmd, '!')

--   -- If the netrw plugin isn't loaded we silently skip everything.
--   if not vim.fn.exists(":Nread") then
--     if vim.o.verbose then
--       print('spellfile#LoadFile(): Nread command is not available.')
--     end
--     return
--   end
--   lang = lang:lower()

--   -- If the URL changes we try all files again.
--   if spellfile_URL ~= vim.g.spellfile_URL then
--     donedict = {}
--     spellfile_URL = vim.g.spellfile_URL
--   end

--   -- I will say this only once!
--   if donedict[lang .. vim.o.enc] then
--     if vim.o.verbose then
--       print('spellfile#LoadFile(): Tried this language/encoding before.')
--     end
--     return
--   end
--   donedict[lang .. vim.o.enc] = 1

--   -- Find spell directories we can write in.
--   local dirlist, dirchoices = spellfile#GetDirChoices()
--   if #dirlist == 0 then
--     local dir_to_create = spellfile#WritableSpellDir()
--     if vim.o.verbose or dir_to_create ~= '' then
--       print('spellfile#LoadFile(): No (writable) spell directory found.')
--     end
--     if dir_to_create ~= '' then
--       vim.fn.mkdir(dir_to_create, "p")
--       -- Now it should show up in the list.
--       dirlist, dirchoices = spellfile#GetDirChoices()
--     end
--     if #dirlist == 0 then
--       print('Failed to create: '..dir_to_create)
--       return
--     else
--       print('Created '..dir_to_create)
--     end
--   end

--   -- Rest of the code...
-- end
