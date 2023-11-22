local stub = require("luassert.stub")

describe("Setup", function()
	it("loads with default config", function()
		local spellfile = require("spellfile_nvim")
		assert.are.same(spellfile.config.url, "https://ftp.nluug.nl/pub/vim/runtime/spell")
	end)

	it("loads with custom config", function()
		local spellfile = require("spellfile_nvim")
		spellfile.setup({ url = "42" })
		assert.are.same(spellfile.config.url, "42")
	end)
end)

describe("Load file", function()
	it("adds current language to the done table", function()
		local spellfile = require("spellfile_nvim")
		spellfile.load_file("en")
		assert.are.same(spellfile.done, { ["en.utf-8.spl"] = true })
	end)

	it("does not retry a language", function()
		vim.o.encoding = "utf-8"
		local spellfile = require("spellfile_nvim")
		spellfile.done["en.utf-8.spl"] = true

		local notify = stub(vim, "notify")
		spellfile.load_file("En")
		assert.stub(notify).was_called_with("Already tried this language before: en")
		assert.are.same(spellfile.done, { ["en.utf-8.spl"] = true })
	end)
end)

describe("Directory choices function", function()
	it("returns at least one directory", function()
		local spellfile = require("spellfile_nvim")
		local choices = spellfile.directory_choices()
		assert.is_true(#choices >= 1)
	end)
end)

describe("File name", function()
	it("returns the correct file name", function()
		local spellfile = require("spellfile_nvim")
		local file_name = spellfile.file_name("en")
		assert.are.same(file_name, "en.utf-8.spl")
	end)
end)

describe("Exists function", function()
	it("returns true when the spell file exists", function()
		local path = require("spellfile_nvim.path")
		path.is_file = function()
			return true
		end

		local spellfile = require("spellfile_nvim")
		assert.is_true(spellfile.exists("en"))
	end)

	it("returns false when the spell file exists", function()
		local path = require("spellfile_nvim.path")
		path.is_file = function()
			return false
		end

		local spellfile = require("spellfile_nvim")
		assert.is_false(spellfile.exists("en"))
	end)
end)
