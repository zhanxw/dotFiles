#!/bin/bash -xe
cd ..

# Emacs
if [[ -f .emacs || -d emacs || .emacs.d ]]; then
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

cd -
