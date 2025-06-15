#!/bin/bash

set -euo pipefail

SELF_DIR="$(realpath --relative-to ~/ "$(dirname "$0")")"

# Link configs and common directories
for file in vimrc tmux.conf bin gitconfig; do
  echo rm -rf "~/.$file" 1>&2
  rm -rf ~/."$file" || true
  echo ln -s "$SELF_DIR/$file" "~/.$file" 1>&2
  ln -s "$SELF_DIR/$file" ~/."$file"
done
RC_LINE="source ~/'$SELF_DIR/bashrc'"
if ! grep -F -q "$RC_LINE" ~/.bashrc; then
  echo "$RC_LINE" >> ~/.bashrc
fi

