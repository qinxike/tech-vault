# 构建并部署到本地目录

cd /Users/qinxike/works/quartz-sites/tech-vault-site/

# 0. 同步文档到content
./deploy/sync-notes.sh

# 1.build默认输出到content目录
npx quartz build

# 2.同步到服务器目录
#scp ./content/* qinxike@macmini-web:/Users/qinxike/works/deploy/tech-vault-site/
# 旧版不支持参数: --iconv=UTF8-MAC,UTF-8
rsync -a --delete \
--exclude ".git/" \
--exclude ".obsidian/" \
--exclude ".trash/" \
--exclude ".DS_Store" \
./public/ qinxike@macmini-web:/Users/qinxike/works/deploy/tech-vault-site/

# git commit
git add .
git commit -am "commit by script"
git pull
git push

