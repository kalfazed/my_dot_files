# My Dot Files
Hey guys, here are some useful dotfiles that I used for everyday! 
Please select the packages you want to install. It is very easy
to install my dot files in your environment. In each directory, 
I put a `install.sh` for the quick installation. Please enjoy!!

## Recommandation
Before the installation, I highly recommand to use [NerdFont](https://www.nerdfonts.com/) 
as the default font in your terminal or vscode. 
Nerd Fonts is a project that takes existing programming fonts and
enhances them with a variety of additional glyphs and icons 
commonly used in programming, development, and computing in general. There are a number of fonts to select in NerdFont. Among all of them, I use `Hack Nerd Font`, you can download from [here](https://www.nerdfonts.com/font-downloads).


## Intallation
Here are some highlights and installation for each item:
## bash
```shell
bash bash/install.sh
```

- Using peco to live grep history command quickly. The shorcut key is `Ctrl + r`
- A list of alias which will increase your productivity.
- `ls` all automatically after `cd` a directory
- Custmized prompt name, which can help you to quickly identify which server are you running. It is convinient when you have multiple server to ssh, including docker container.
- Show icons for each file type and directory
- Show git branch and status in prompt.
- use `z` to jump to a frequently access directory quickly. 

## fish
```shell
bash fish/install.sh
```
### Details
- `fish shell` is an alternative shell for bash.
- All above features in bash are also included in fish

## lvim
```shell
bash lvim/install.sh
```
`lvim` is short for `lunarvim`, which is implemented based on `neovim`. The global configuration is located
in `~/.config/lvim/config.lua`. However, you can also customize some plugins in `~/.config/lvim/lua`.
Currently, in the configuration, I've customized following things:
- `autocommands`: automatically run a command when launch a file.
- `chatgpt`: run chatgpt inside nvim
- `keymaps`: customized keymaps list
- `nvimtree`: customized nvimtree (change the nvimtree location, and visualization of git status)
- `outline`: can shows the outline of a file. Super easy to use when you are reading a huge C++ code.
- `signature`: can show function signature when you type. 
- `telescope`: custmized telescope visualization and shortcut keys
- `treesitter`: highlighting the file depending on different programming launguages.
- others:
    - `markdown-preview`: preview a markdown file in browser with synchronised and flexible configuration.
    - `bracey`: plugin for live html, css, and javascript editing in vim
    - `nvim-colorizer`: a high-performance color highlighter for Neovim which has no external dependencies.
    - `nvim-dap`: a Debug Adapter Protocol client implementation for neovim.
    - `nvim-dap-python`: an extension for nvim-dap providing default configurations for python and methods to debug individual test methods or classes.
    - `nvim-dap-projects`: a very simple plugin which implements "per-project" nvim-dap debugger adapters and configurations.
    - `nvim-dap-ui`: a UI for nvim-dap which provides a good out of the box configuration.

### Additional installation
You can install lsp(launguage server protocal) to different language. In the normal mode, try following commands:
```shell
:LspInstall clangd
:LspInstall pyright
```

You can also install dubugger using following commands:
```shell
:MasonInstall codelldb
:MasonInstall debugpy
```


## tmux
```shell
bash tmux/install.sh
```
One of the highlighs of the tmux configuration in this repository
is that it uses powerline to enhance the visualization of status
bar. Besides, the default action key is changed from `Ctrl + b`
into `Ctrl + a`