# chairmanK's dotfiles

These are my personalized configuration files. I give permission to use
and modify them without restriction. I provide absolutely no guarantee
that they will not trash your system. Use at your own risk.

## Dependencies

- Bash(-like) shell
- [X11](http://www.x.org) and xterm
- [xmonad](http://xmonad.org/), version 0.91
- [xmobar](http://projects.haskell.org/xmobar/), version 0.11
- [dmenu](https://github.com/chairmanK/dmenu)
- [Vim](http://www.vim.org), version 7.3 (compiled with multi-byte
  support)
- [slock](http://tools.suckless.org/slock) and xautolock

The following projects are included as sub-modules:

- [pathogen.vim](https://github.com/tpope/vim-pathogen)
- [fugitive.vim](https://github.com/tpope/vim-fugitive)
- [vim-eunuch](https://github.com/tpope/vim-eunuch.git)
- [vim-surround](https://github.com/tpope/vim-surround.git)
- [ctrlp](https://github.com/kien/ctrlp.vim.git)
- [NERD tree](https://github.com/scrooloose/nerdtree)
- [VimClojure](https://github.com/vim-scripts/VimClojure)
- [vim-slime](https://github.com/jpalardy/vim-slime.git)
- [solarized](https://github.com/altercation/solarized.git)
- [solarized-xmonad](https://github.com/ibotty/solarized-xmonad.git)

## Installation

I wrote a simple, stupid shell script that creates symlinks in your
$HOME. To install, do the following:

    git clone git://github.com/chairmanK/dotfiles ~/.dotfiles
    cd ~/.dotfiles
    ./install

I have not yet written an uninstall tool to automatically remove the
symlinks.
