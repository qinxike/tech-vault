#!/bin/zsh
SRC="/Users/qinxike/works/knowledge-vault/tech-vault"
DEST="./content"
rsync -av --delete \
  --exclude ".git/" \
	--exclude ".obsidian/" \
  --exclude ".trash/" \
  --exclude ".DS_Store" \
  --exclude ".*" \
  $SRC/ $DEST/

