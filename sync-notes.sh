#!/bin/zsh

# 过滤所有.开头的文件, .开头的文件夹
SRC="/Users/qinxike/works/knowledge-vault/tech-vault"
DEST="./content"
rsync -av --delete \
  --iconv=UTF8-MAC,UTF-8 \
	--exclude ".git/" \
	--exclude ".obsidian/" \
  --exclude ".trash/" \
  --exclude ".DS_Store" \
	--exclude ".*/" \
  --exclude ".[^/]*" \
  $SRC/ $DEST/

