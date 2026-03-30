#!/bin/zsh

backup() {
  target=$1
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.backup"
    echo "-----> Moved $target to $target.backup"
  fi
}

symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    echo "-----> Symlinking $link"
    ln -s $file $link
  fi
}

DOTFILES=$PWD

# Shell
backup ~/.aliases && symlink $DOTFILES/shell/aliases ~/.aliases
backup ~/.zshrc   && symlink $DOTFILES/shell/zshrc   ~/.zshrc

# Git
backup ~/.gitconfig && symlink $DOTFILES/git/gitconfig ~/.gitconfig

# Claude
mkdir -p ~/.claude
backup ~/.claude/CLAUDE.md      && symlink $DOTFILES/claude/CLAUDE.md      ~/.claude/CLAUDE.md
backup ~/.claude/settings.json  && symlink $DOTFILES/claude/settings.json  ~/.claude/settings.json
backup ~/.claude/hooks          && symlink $DOTFILES/claude/hooks           ~/.claude/hooks
backup ~/.claude/skills         && symlink $DOTFILES/claude/skills          ~/.claude/skills

echo "👌 Done!"
exec zsh