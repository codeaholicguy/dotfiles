# dotfiles
My set of `vim`, `zsh`, and `tmux` configuration files.

![Screenshot](screenshot.png)

Install
-------

Clone onto your machine:

    git clone git://github.com/codeaholicguy/dotfiles.git

Simply run file:

    ./install.sh

If you have [`neovim`](https://github.com/neovim/neovim) in your machine, run:

    ./install.sh --nvim

In `vim/neovim` run:

    :PlugInstall

If you want to get newest version of `vim/neovim` plugin, in `vim/neovim` simply run:
    
    :PlugUpdate

Usage
-----

###tmux

```
Leader `<C-b>`
Create new window `<Leader> c`
New session `<Leader> :` type `new`
Split pane vertical `<Leader> \`
Split pane horizontal `<Leader> /`
Adjust pane size `<Leader> h` (hjkl)
Switch window `<Leader> 0` (0..9)
Next session `<Leader> )` / Prev session `<Leader> (`
Close window `<Leader> &`
Close pane `<C-d>`
Change session name `<Leader> $`
```

###vim

```
Leader `<Space>`
Split vertical `<Leader> \`
Split horizontal `<Leader> /`
Search all `\`
Togle tree view `<Leader> n`
Search under cursor `<Leader> k`
```
