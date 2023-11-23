local stub = require("luassert.stub")

describe("Setup", function()
	after_each(function()
		package.loaded["spellfile_nvim"] = nil
	end)

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

describe("Parse", function()
	it("returns the correct encoding", function()
		local spellfile = require("spellfile_nvim")
		local data = spellfile.parse("en")
		assert.are.same(data.encoding, "utf-8")
	end)

	it("returns the correct language code", function()
		local spellfile = require("spellfile_nvim")
		local data = spellfile.parse("EN")
		assert.are.same(data.lang, "en")
	end)

	it("returns the correct file name", function()
		local spellfile = require("spellfile_nvim")
		local data = spellfile.parse("en")
		assert.are.same(data.file_name, "en.utf-8.spl")
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

describe("Download", function()
	it("downloads the file using curl", function()
		local spellfile = require("spellfile_nvim")

		local notify = stub(vim, "notify")
		local system = stub(vim.fn, "system")
		spellfile.directory_choices = function()
			return { "/tmp" }
		end
		vim.fn.executable = function(name)
			if name == "curl" then
				return 1
			end
			return 0
		end

		spellfile.download("en")
		assert.stub(notify).was_called_with("Downloading en...")
		assert
			.stub(system)
			.was_called_with("curl -fLo /tmp/en.utf-8.spl https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl")
	end)

	it("downloads the file using wget", function()
		local spellfile = require("spellfile_nvim")

		local notify = stub(vim, "notify")
		local system = stub(vim.fn, "system")
		spellfile.directory_choices = function()
			return { "/tmp" }
		end
		vim.fn.executable = function(name)
			if name == "wget" then
				return 1
			end
			return 0
		end

		spellfile.download("en")
		assert.stub(notify).was_called_with("Downloading en...")
		assert
			.stub(system)
			.was_called_with("wget -O /tmp/en.utf-8.spl https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl")
	end)

	it("shows error when there is no curl or wget", function()
		local spellfile = require("spellfile_nvim")

		local notify = stub(vim, "notify")
		local system = stub(vim.fn, "system")
		spellfile.directory_choices = function()
			return { "/tmp" }
		end
		vim.fn.executable = function(name)
			return 0
		end

		spellfile.download("en")
		assert.stub(notify).was_called_with("No curl or wget found. Please install one of them.")
		assert.stub(system).was_not_called()
	end)

	it("asks for confirmation and cancels if user does not confirm", function()
		local spellfile = require("spellfile_nvim")

		local notify = stub(vim, "notify")
		local system = stub(vim.fn, "system")
		vim.fn.input = function()
			return "n"
		end

		spellfile.download("en", true)
		assert.stub(notify).was_not_called()
		assert.stub(system).was_not_called()
	end)

	it("asks for confirmation and proceeds if user confirms", function()
		local spellfile = require("spellfile_nvim")

		local notify = stub(vim, "notify")
		local system = stub(vim.fn, "system")
		vim.fn.input = function()
			return "n"
		end
		spellfile.directory_choices = function()
			return { "/tmp" }
		end
		vim.fn.executable = function(name)
			return 0
		end

		spellfile.download("en")
		assert.stub(notify).was_called_with("No curl or wget found. Please install one of them.")
		assert.stub(system).was_not_called()
	end)
end)

describe("Choose directory", function()
	it("shows notification when there are no directories", function()
		local spellfile = require("spellfile_nvim")
		spellfile.directory_choices = function()
			return {}
		end

		local notify = stub(vim, "notify")
		assert.is_nil(spellfile.choose_directory())
		assert.stub(notify).was_called_with("No spell directory found in the runtimepath")
	end)

	it("returns the first directory when there is only one", function()
		local spellfile = require("spellfile_nvim")
		spellfile.directory_choices = function()
			return { "/tmp" }
		end

		local choice = spellfile.choose_directory()
		assert.are.same(choice, "/tmp")
	end)

	it("asks for user input when there are multiple directories", function()
		local spellfile = require("spellfile_nvim")

		spellfile.directory_choices = function()
			return { "/tmp/1", "/tmp2" }
		end
		vim.fn.inputlist = function()
			return 1
		end

		assert.are.same("/tmp/1", spellfile.choose_directory())
	end)

	it("returns nil when user chooses a non-existent option", function()
		local spellfile = require("spellfile_nvim")

		spellfile.directory_choices = function()
			return { "/tmp/1", "/tmp2" }
		end
		vim.fn.inputlist = function()
			return 42
		end

		assert.is_nil(spellfile.choose_directory())
	end)
end)
