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
    ln -s dotFiles/git/.gitconfig
    echo "If need to set up proxy, add these to .gitconfig:"
    echo "[http]"
    echo "	proxy = http://proxy.swmed.edu:3128"
    echo "[https]"
    echo "	proxy = http://proxy.swmed.edu:3128"
fi

cd -

