# `spellfile.nvim` [![Tests](https://github.com/cuducos/spellfile.nvim/actions/workflows/tests.yml/badge.svg)](https://github.com/cuducos/spellfile.nvim/actions/workflows/tests.yml) [![StyLua](https://github.com/cuducos/spellfile.nvim/actions/workflows/stylua.yml/badge.svg)](https://github.com/cuducos/spellfile.nvim/actions/workflows/stylua.yml)

Alternative for Vim's native `spellfile.vim` written in Lua and with no dependency on `netrw`.

## Context

It looks like that nice feature of Vim/Neovim that automatically downloads missing spell files (e.g. on `:set spell spelllang=pt`) depends entirely on `netwr`:
* There's [an issue on Neovim](https://github.com/neovim/neovim/issues/7189)
* And there's [this](https://github.com/neovim/neovim/blob/7e97c773e3ba78fcddbb2a0b9b0d572c8210c83e/runtime/autoload/spellfile.vim#L19) on native's `spellfile.vim`

Native `spellfile.vim` works [using a `SpellFileMissing` auto command](https://github.com/neovim/neovim/blob/7e97c773e3ba78fcddbb2a0b9b0d572c8210c83e/runtime/doc/spell.txt#L657-L658), and:
* has no other dependency than Neovim
* uses the same `autocmd` for seamless integration

You can see it working (without changing your config) by cloning this repo and:

```console
$ nvim -u tests/init.lua
```

From there, try setting a lanaguide that is not installed, e.g. `:set spell spelllang=pt`.

## Install

### With [`lazy.nvim`](https://github.com/folke/lazy.nvim)

```lua
{ "cuducos/spellfile.nvim" }
```

### With [`packer.nvim`](https://github.com/wbthomason/packer.nvim):

```lua
use { "cuducos/spellfile.nvim" }
```

### With [`vim-plug`](https://github.com/junegunn/vim-plug):

```viml
Plug 'cuducos/spellfile.nvim'
```

## Tests

```console
$ nvim --headless -u tests/init.lua -c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/init.lua' }"
```
