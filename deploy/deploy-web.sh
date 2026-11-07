#!/usr/bin/env bash

# 构建并部署到指定目录 #
# 定时crontab + 手动双模式

# 任何一步失败立即中止，避免"构建失败但旧产物被 rsync --delete 清掉"
set -euo pipefail

SITE_DIR="/Users/qinxike/works/quartz-sites/tech-vault-site"
NOTES_DIR="/Users/qinxike/works/knowledge-vault/tech-vault"
REMOTE_HOST="qinxike@macmini-web"
REMOTE_DIR="/Users/qinxike/works/deploy/tech-vault-site"
LOCK="/tmp/tech-vault-site.deploy.lock"

# 简单锁：防止 crontab 与手动执行撞车（macOS 无 flock，用 mkdir 原子锁）
mkdir "$LOCK" 2>/dev/null || { echo "上一次部署还在进行，跳过"; exit 0; }
trap 'rmdir "$LOCK"' EXIT

echo "==== $(date '+%F %T') 开始部署 ===="
cd "$SITE_DIR"

# 0. 同步笔记到 content
./deploy/sync-notes.sh

# 1. 本地构建（产物在public/，注意不是content/）
npx quartz build

# 2. 构建产物同步到本地服务器部署目录
rsync -a --delete \
  --exclude ".git/" \
	--exclude ".obsidian/" \
	--exclude ".workbuddy/" \
	--exclude "private/" \
	--exclude "私密文件夹/" \
  --exclude "raw-news/" \
  --exclude ".DS_Store" \
	--exclude ".*/" \
	--exclude ".gitignore" \
  ./public/ "$REMOTE_HOST:$REMOTE_DIR/"

# 3. 提交推送，触发 GitHub Actions 云端构建
if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -m "deploy: auto publish $(date '+%F %T')"
fi
git pull --rebase --autostash
git push

echo "==== 部署完成 ===="
# osascript通知; 后续可用Server 将/bark 推送到微信?
osascript -e 'display notification "tech-vault-site 部署完成" with title "Deploy"' 2>/dev/null || true

