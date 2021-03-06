[![Gitter](https://badges.gitter.im/nvim-treesitter/community.svg)](https://gitter.im/nvim-treesitter/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
![Linting and style checking](https://github.com/nvim-treesitter/nvim-treesitter/workflows/Linting%20and%20style%20checking/badge.svg?branch=master)
![Check loading of syntax files](https://github.com/nvim-treesitter/nvim-treesitter/workflows/Check%20loading%20of%20syntax%20files/badge.svg)

# nvim-treesitter

Treesitter configurations and abstraction layer for Neovim.

![Nvim-treesitter](nvim-treesitter.png)

Traditional highlighting (left) vs Treesitter-based highlighting (right).

**Warning: Treesitter and Treesitter highlighting are an experimental feature of nightly versions of Neovim.
Please consider the experience with this plug-in as experimental until Neovim 0.5 is released!**

# Quickstart

## Requirements

- Neovim [nightly](https://github.com/neovim/neovim#install-from-source)
- `git` in your path.
- A C compiler in your path.

## Installation

You can install `nvim-treesitter` with your favorite package manager, or using the default `pack` feature of Neovim!

### Using a package manager

Simply add these lines to your `init.vim` :

```vim
Plug 'nvim-treesitter/nvim-treesitter'
```

### Using Neovim `pack` feature

We highly recommend reading `:h packages` to learn more about this feature, but you can still follow these steps:

```sh
$ mkdir -p ~/.local/share/nvim/site/pack/nvim-treesitter/start
$ cd ~/.local/share/nvim/site/pack/nvim-treesitter/start
$ git clone https://github.com/nvim-treesitter/nvim-treesitter.git
```

## Adding parsers

Treesitter uses a different _parser_ for every language. It can be quite a pain to install, but fortunately `nvim-treesitter`
provides two command to tackle this issue:

- `TSInstall {language}` to install one or more parsers.
  `TSInstall <tab>` will give you a list of supported languages, or select `all` to install them all.
- `TSInstallInfo` to know which parser is installed.

Let's say you need parsers for `lua`, this is how you do with these commands:

```vim
:TSInstall lua
Downloading...
Compiling...
Treesitter parser for lua has been installed
```

Cool, lets see which parsers are installed:

```vim
:TSInstallInfo
lua        [✓] installed
c          [✗] installed
html       [✗] not installed
typescript [✗] not installed
...
```

And now you should be ready to use every functionality `nvim-treesitter` provides!

## Setup

All modules are disabled by default,
so you'll need to activate them by putting this in your `init.vim`:

```lua
lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,                    -- false will disable the whole extension
      disable = { "c", "rust" },        -- list of language that will be disabled
      custom_captures = {               -- mapping of user defined captures to highlight groups
        -- ["foo.bar"] = "Identifier"   -- highlight own capture @foo.bar with highlight group "Identifier", see :h nvim-treesitter-query-extensions
      },
    },
    incremental_selection = {
      enable = true,
      disable = { "cpp", "lua" },
      keymaps = {                       -- mappings for incremental selection (visual mappings)
        init_selection = "gnn",         -- maps in normal mode to init the node/scope selection
        node_incremental = "grn",       -- increment to the upper named parent
        scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
        node_decremental = "grm",       -- decrement to the previous node
      }
    },
    refactor = {
      highlight_definitions = {
        enable = true
      },
      highlight_current_scope = {
        enable = true
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "grr"          -- mapping to rename reference under cursor
        }
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = "gnd",      -- mapping to go to definition of symbol under cursor
          list_definitions = "gnD"      -- mapping to list all definitions in current file
        }
      }
    },
    textobjects = { -- syntax-aware textobjects
    enable = true,
    disable = {},
    keymaps = {
        ["iL"] = { -- you can define your own textobjects directly here
          python = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
          java = "(method_declaration) @function"
        },
        -- or you use the queries from supported languages with textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aC"] = "@class.outer",
        ["iC"] = "@class.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        ["ae"] = "@block.outer",
        ["ie"] = "@block.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["is"] = "@statement.inner",
        ["as"] = "@statement.outer",
        ["ad"] = "@comment.outer",
        ["am"] = "@call.outer",
        ["im"] = "@call.inner"
      }
    },
    ensure_installed = "all" -- one of "all", "language", or a list of languages
}
EOF
```

## Commands

Each feature can be enabled or disabled by different means:

```vim
:TSBufEnable {module} " enable module on current buffer
:TSBufDisable {module} " disable module on current buffer
:TSEnableAll {module} [{ft}] " enable module on every buffer. If filetype is specified, enable only for this filetype.
:TSDisableAll {module} [{ft}] " disable module on every buffer. If filetype is specified, disable only for this filetype.
:TSModuleInfo [{module}] " list information about modules state for each filetype
```

## Features and Roadmap

The goal of `nvim-treesitter` is both to provide a simple and easy way to use the interface for Treesitter in Neovim,
but also to add some functionalities to it:

Some of these features are:

- [x] Incremental selection
- [x] Syntax based code folding (`set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()`)
- [x] Consistent syntax highlighting (the api is not quite stable yet)
- [x] Statusline indicator (`require'nvim-treesitter'.statusline(size)`)

You can find the roadmap [here](https://github.com/nvim-treesitter/nvim-treesitter/projects/1).
The roadmap and all features of this plugin are open to change, and any suggestion will be highly appreciated!

## Available Modules

- `highlight`: Consistent syntax highlighting.
- `incremental_selection`: Syntax based selection.
- `refactor.highlight_definitions`: Syntax based definition and usage highlighting.
- `refactor.smart_rename`: Syntax based definition and usage renaming.
- `refactor.navigation`: Syntax based definition listing and navigation.
  * List all definitions
  * Go to definition
- `textobjects`: Vim textobjects defined by treesitter queries

## Defining Modules

Users and plugin authors can take advantage of modules by creating their own. Modules provide:

- Treesitter language detection support
- Attach and detach to buffers
- Works with all nvim-treesitter commands

You can use the `define_modules` function to define one or more modules or module groups.

```lua
require 'nvim-treesitter'.define_modules {
  my_cool_plugin = {
    attach = function(bufnr, lang)
      -- Do cool stuff here
    end,
    detach = function(bufnr)
      -- Undo cool stuff here
    end,
    is_supported = function(lang)
      -- Check if the language is supported
    end
  }
}
```

Modules can consist of the following properties:

- `module_path`: A require path (string) that exports a module with an `attach` and `detach` function. This is not required if the functions are on this definition.
- `enable`: Determines if the module is enabled by default. This is usually overridden by the user.
- `disable`: A list of languages that this module is disabled for. This is usually overridden by the user.
- `is_supported`: A function that takes a language and determines if this module supports that language.
- `attach`: A function that attaches to a buffer. This is required if `module_path` is not provided.
- `detach`: A function that detaches from a buffer. This is required if `module_path` is not provided.

## Utils

You can get some utility functions with

```lua
local ts_utils = require 'nvim-treesitter.ts_utils'
```
More information is available in the help file (`:help nvim-treesitter-utils`).

## Supported Languages

For `nvim-treesitter` to work, we need to use query files such as those you can find in
`queries/{lang}/{locals,highlights,textobjects}.scm`

We are looking for maintainers to write query files for their languages.

List of currently supported languages:

- [x] bash (maintained by @TravonteD)
- [x] c (maintained by @vigoux)
- [x] cpp (maintained by @theHamsta, extends C queries)
- [x] csharp (maintained by @svermeulen)
- [x] css (maintained by @TravonteD)
- [x] dart (maintained by @Akin909)
- [ ] elm
- [x] go (maintained by @theHamsta, @WinWisely268)
- [ ] haskell
- [x] html (maintained by @TravonteD)
- [x] java
- [x] javascript (maintained by @steelsojka)
- [ ] jsdoc
- [x] json (maintained by @steelsojka)
- [ ] julia
- [x] lua  (maintained by @vigoux)
- [ ] markdown
- [ ] nix
- [ ] ocaml
- [x] php (maintained by @tk-shirasaka)
- [x] python (maintained by @theHamsta)
- [x] regex (maintained by @theHamsta)
- [x] rst (maintained by @stsewd)
- [x] ruby (maintained by @TravonteD)
- [x] rust (partial support, maintained by @vigoux)
- [ ] scala
- [ ] swift
- [x] toml (maintained by @tk-shirasaka)
- [x] tree-sitter query language (maintained by @steelsojka)
- [ ] tsx
- [x] typescript (maintained by @steelsojka)
- [ ] vue
- [ ] yaml

## User Query Extensions

You can add your own query files by placing a query file in vim's runtime path after `nvim-treesitter` is sourced.
If the language has a built in query file, that file will be appended to or it will be used (useful for languages not yet supported).
For example, you can add files to `<vim-config-dir>/after/queries/lua/highlights.scm` to add more queries to lua highlights.
You can also manually add query paths to the runtime path by adding this to your vim config `set rtp+='path/to/queries'`.

## Troubleshooting

Before doing anything run `:checkhealth nvim_treesitter`. This will help you find where the bug might come from.

### Feature `X` does not work for `{language}`...

First, check the `## {language} parser healthcheck` section of `:checkhealth` if you have any warning.
If you do, it's highly possible that this is the cause of the problem.
If everything is okay, then it might be an actual error.

In both cases, feel free to [open an issue here](https://github.com/nvim-treesitter/nvim-treesitter/issues/new/choose).

### I experience weird highlighting issues similar to [#78](https://github.com/nvim-treesitter/nvim-treesitter/issues/78)

This is a well known issue, which arise when the tree and the buffer are getting out of sync.
As this issue comes from upstream, we don't have any finite fix. To get around this, you can force reparsing the buffer with this command:

```vim
:write | edit | TSBufEnable highlight
```

This will save, restore and enable highlighting for the current buffer, fixing the issue.
