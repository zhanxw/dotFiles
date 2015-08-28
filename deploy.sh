#!/bin/bash -xe
cd ..

# Emacs
if [[ -f .emacs || -d emacs || -d .emacs.d ]]; then
  echo "Emacs setting exists, skipping..."
else
    ln -s dotFiles/emacs/.emacs
    ln -s dotFiles/emacs/emacs
    ln -s dotFiles/emacs/.emacs.d
    emacs --batch --eval '(byte-recompile-directory "~/.emacs.d")'
    echo "Emacs setting set up"    
fi

# Screen
if [[ -f .screenrc ]]; then
    echo "Screen setting exists, skipping..."
else
    ln -s dotFiles/screen/.screenrc
    echo "Screen setting set up"
fi

# Git
if [[ -f .gitconfig ]]; then
    echo "Git setting exists, skipping..."
else
    useProxy="$(ifconfig |grep 129.112)"
    if [ -z "$useProxy" ]; then
      ln -s dotFiles/git/.gitconfig
    else
      echo "  Enable proxy settings"
      sed 's:#\([ \t]\+proxy\):\1:g' dotFiles/git/.gitconfig > .gitconfig
    fi
    echo "Git setting set up"    
fi

# bash
if grep "dotFiles/bash/.bashrc" ~/.bashrc >&/dev/null
then
    echo "Bash exists, skipping..."
else
    echo "if [[ -f ~/dotFiles/bash/.bashrc ]]; then source ~/dotFiles/bash/.bashrc; fi" >> ~/.bashrc
    echo "Bash setting set up"        
fi

cd -

# gdb
if [[ -f .gdbinit ]]; then
    echo "GDB setting exists, skipping..."
else
    ln -s dotFiles/gdb/.gdbinit
    echo "GDB setting set up"
fi

