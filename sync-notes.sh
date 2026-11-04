#!/bin/zsh

# 过滤所有.开头的文件, .开头的文件夹
SRC="/Users/qinxike/works/knowledge-vault/tech-vault"
DEST="./content"
rsync -av --delete \
	--exclude "_templater/" \
	--exclude ".git/" \
	--exclude ".gitignore" \
	--exclude ".obsidian/" \
  --exclude ".trash/" \
  --exclude ".DS_Store" \
	--exclude ".*/" \
  --exclude ".*" \
  $SRC/ $DEST/

# 新版rsync才支持mac中文名文件,参数: --iconv=UTF8-MAC,UTF-8 \

