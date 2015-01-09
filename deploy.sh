#!/bin/bash -xe
cd ..

# Emacs
if [[ -f .emacs || -d emacs || -d .emacs.d ]]; then
  echo "Emacs setting exists, skipping..."
else
    ln -s dotFiles/emacs/.emacs
    ln -s dotFiles/emacs/emacs
    ln -s dotFiles/emacs/.emacs.d
fi

# Screen
if [[ -f .screenrc ]]; then
    echo "Screen setting exists, skipping..."
else
    ln -s dotFiles/screen/.screenrc
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
fi

cd -

