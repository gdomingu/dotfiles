#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

ln -s $(pwd)/tmux.conf $HOME/.tmux.conf
ln -s $(pwd)/vimrc $HOME/.vimrc
ln -s $(pwd)/vim $HOME/.vim
ln -s $(pwd)/emacs $HOME/.emacs
ln -s $(pwd)/screenrc $HOME/.screenrc

vim -Es -u $HOME/.vimrc -c "PlugInstall | qa"
#!/bin/sh
# Install all dotfiles into the home directory

set -e

# Figure out the absolute path of the dotfiles directory
DOTFILESDIRREL="$(dirname "$0")"
cd $DOTFILESDIRREL
DOTFILESDIR="$(pwd -P)"

for DOTFILE in .??*; do
  HOMEFILE="$HOME/$DOTFILE"
  [ -d $DOTFILE ] && DOTFILE="$DOTFILE/"
  DIRFILE="$DOTFILESDIR/$DOTFILE"

  # Don't try to install documentation/script files
  echo $DOTFILE | egrep -q '(^script/$|\.txt$|\.md$)' && continue

  if [ -L "$HOMEFILE" ] && ! [ -d "$DOTFILE" ]
  then
    # Create (and overwrite if needed) file symlinks
    ln -sfv "$DIRFILE" "$HOMEFILE"
  else
    # Create (and delete existing directory if needed) directory symlinks
    rm -rfv "$HOMEFILE" 2>/dev/null
    ln -sv "$DIRFILE" "$HOMEFILE"
  fi
done