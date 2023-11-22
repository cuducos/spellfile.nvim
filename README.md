# `spellfile.nvim` work in progress [![Tests](https://github.com/cuducos/spellfile.nvim/actions/workflows/tests.yml/badge.svg)](https://github.com/cuducos/spellfile.nvim/actions/workflows/tests.yml) [![StyLua](https://github.com/cuducos/spellfile.nvim/actions/workflows/stylua.yml/badge.svg)](https://github.com/cuducos/spellfile.nvim/actions/workflows/stylua.yml)

It looks like that nice feature of Vim/Neovim that automatically downloads missing spell files (e.g. on `:set spell spelllang=pt`) depends entirely on `netwr`:
* There's [an issue on Neovim](https://github.com/neovim/neovim/issues/7189)
* And there's [this](https://github.com/neovim/neovim/blob/7e97c773e3ba78fcddbb2a0b9b0d572c8210c83e/runtime/autoload/spellfile.vim#L19) on native's `spellfile.vim`

Native `spellfile.vim` works [using a `SpellFileMissing` auto command](https://github.com/neovim/neovim/blob/7e97c773e3ba78fcddbb2a0b9b0d572c8210c83e/runtime/doc/spell.txt#L657-L658), so the plan is to create a plugin that:
* has no other dependency than Neovim (ideally 0.6+, but let's work with the best API possible)
* re-write `spellfile.vim` in Lua (without depending on `netwr`)
* uses the same `autocmd` for seamless integration

## Tests

```console
$ nvim --headless -u tests/init.lua -c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/init.lua' }"
```
