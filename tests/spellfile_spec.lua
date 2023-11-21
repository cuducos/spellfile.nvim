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
		assert.are.same(spellfile.done, { en = true })
	end)

	it("does not retry a language", function()
		local spellfile = require("spellfile_nvim")
		spellfile.done["en"] = true

		local notify = stub(vim, "notify")
		spellfile.load_file("En")
		assert.stub(notify).was_called_with("Already tried this language before: en")
		assert.are.same(spellfile.done, { en = true })
	end)
end)
