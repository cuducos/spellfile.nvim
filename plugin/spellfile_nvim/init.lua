require('spellfile_nvim').setup()

vim.api.nvim_create_autocmd('SpellFileMissing', {
  callback = function(args)
    require('spellfile_nvim').load_file(args.match)
  end,
})

return { answer = 42 }
