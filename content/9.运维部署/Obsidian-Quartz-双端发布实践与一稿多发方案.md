---
title: Obsidian + Quartz + rsync：本地双端发布的博客工作流
description: Obsidian 写作，Quartz 建站，rsync 同步，一键脚本双端发布（GitHub Pages + 本地服务器），附一稿多发的 AI 方案
tags:
  - obsidian
  - quartz
  - 建站
  - rsync
  - 工作流
  - AI写作
created: 2026-11-05
---

# Obsidian + Quartz + rsync：本地双端发布的博客工作流

> 一句话概括：**Obsidian 里写 markdown，一条脚本同时发布到「GitHub Pages」和「本地服务器」两个端**，再配合 AI 完成「抓热点 → 写稿 → 多平台分发」。
> 本文分两部分：① 建站与双端发布实践；② 一稿多发 + AI 内容生产方案。

---

## 第一部分：建站与双端发布实践

### 1. 架构总览

```
                         ┌── rsync 纯本地路径 ──┐
Obsidian 笔记库          │                      ▼
tech-vault ──sync-notes.sh──▶ content/ ──npx quartz build──▶ public/
     │                        (quartz 仓库)                    │
     │                                                  rsync  │
     │                                                         ▼
     │                                          本地服务器 nginx 部署目录
     │                                          (frp 穿透, 域名直连)
     │
     └── deploy-web.sh 里 git commit + push
                              │
                              ▼
                     GitHub 远程仓库
                              │ push 触发
                              ▼
                  GitHub Actions 自动构建部署 (Pages)
```

**双端同时发布**：本地脚本 rsync 到内网服务器（域名 + frp 穿透可公网访问），git push 触发云端工作流部署 GitHub Pages。任何一端挂了，另一端照常服务。

### 2. 目录结构

```
~/works/
├── knowledge-vault/
│   └── tech-vault/                  # Obsidian 笔记库（git 管理）
├── quartz-sites/
│   └── tech-vault-site/             # Quartz 站点仓库（git 管理，远程指向 GitHub）
│       ├── content/                 # rsync 目标，网站内容的唯一来源
│       ├── public/                  # npx quartz build 的构建产物
│       ├── deploy/
│       │   ├── sync-notes.sh        # 笔记同步脚本
│       │   └── deploy-web.sh        # 一键部署脚本
│       └── quartz.config.yaml
└── deploy/
    └── tech-vault-site/             # 本地服务器的 nginx 部署目录
```

### 3. 实施步骤

#### Step 1：建立笔记库 + git 管理

```bash
mkdir -p ~/works/knowledge-vault/tech-vault
cd ~/works/knowledge-vault/tech-vault
git init && git remote add origin git@github.com:你的用户名/tech-vault.git
```

#### Step 2：Obsidian 三件套插件

| 插件 | 作用 |
|---|---|
| **Obsidian Git** | 笔记库自动定时 commit/push，多机同步 |
| **Quartz Syncer** | 在 Obsidian 内管理 Quartz 站点配置、发布单篇笔记（配本地仓库 + 远程仓库地址） |
| **Templater** | 文章元信息模板（title/description/tags/date/publish），新建博文一键套用 |

Templater 模板示例（存为 `templates/post.md`）：

```markdown
---
title: <% tp.file.title %>
description:
tags: []
date: <% tp.date.now("YYYY-MM-DD") %>
publish: true
---
```

#### Step 3：建立本地 Quartz 仓库

```bash
mkdir -p ~/works/quartz-sites && cd ~/works/quartz-sites
git clone https://github.com/jackyzha0/quartz.git tech-vault-site
cd tech-vault-site
npm ci

# 把 origin 指向自己的 GitHub 仓库
git remote set-url origin git@github.com:你的用户名/tech-vault-site.git
git push -u origin v4        # v4 模板推 v4 分支；v5 模板推 v5 分支
```

然后在 Quartz Syncer 插件设置里同时填：**本地仓库路径**（`~/works/quartz-sites/tech-vault-site`）和**远程仓库地址**。⚠️ 本地仓库务必放在 Obsidian 库外面。

#### Step 4：rsync 同步笔记到 content

`deploy/sync-notes.sh`：

```bash
#!/usr/bin/env bash
set -euo pipefail

rsync -a --delete \
  --exclude ".git/" \
  --exclude ".obsidian/" \
  --exclude ".trash/" \
  --exclude ".DS_Store" \
  /Users/qinxike/works/knowledge-vault/tech-vault/ \
  /Users/qinxike/works/quartz-sites/tech-vault-site/content/
```

> 注：旧版 rsync 不支持 `--iconv=UTF8-MAC,UTF-8`，macOS 自带 rsync 默认就是 UTF-8 NFD，同名文件同名转换，实践中不需要加。

#### Step 5-6：构建 + 部署到本地服务器

```bash
npx quartz build        # 产物输出到 public/ 目录
rsync -a --delete ./public/ qinxike@macmini-web:/Users/qinxike/works/deploy/tech-vault-site/
```

#### Step 7：push 触发云端构建

官方模板自带 `.github/workflows/deploy.yml`，push 到站点分支即自动构建发布 GitHub Pages，无需额外配置。

#### Step 8：本地服务器 nginx 配置

```nginx
server {
    listen 80;
    server_name notes.example.com;          # 域名已通过 frp 指向本机
    root /Users/qinxike/works/deploy/tech-vault-site;
    index index.html;

    gzip on;
    gzip_types text/css application/javascript image/svg+xml;
    location ~* \.(js|css|png|jpg|webp|svg|woff2)$ {
        expires 7d;
    }
}
```

#### Step 9：一键部署脚本 + crontab

`deploy/deploy-web.sh`（在你的原始版本上做了健壮性加固）：

```bash
#!/usr/bin/env bash
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

# 1. 本地构建（产物在 public/，注意不是 content/）
npx quartz build

# 2. 构建产物同步到本地服务器部署目录
rsync -a --delete \
  --exclude ".git/" \
  --exclude ".DS_Store" \
  ./public/ "$REMOTE_HOST:$REMOTE_DIR/"

# 3. 提交推送，触发 GitHub Actions 云端构建
if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -m "deploy: auto publish $(date '+%F %T')"
fi
git pull --rebase --autostash
git push

echo "==== 部署完成 ===="
osascript -e 'display notification "tech-vault-site 部署完成" with title "Deploy"' 2>/dev/null || true
```

crontab（每天 08:00 自动发布，手动随时可跑）：

```bash
crontab -e
# 0 8 * * * /Users/qinxike/works/quartz-sites/tech-vault-site/deploy/deploy-web.sh >> /tmp/tech-vault-site.deploy.log 2>&1
```

### 4. 对现有方案的改进建议

当前方案（本地构建 + rsync + git 双通道）对「本地服务器也要部署产物」的场景是**合理最优解**，不建议推翻。以下是低成本增补：

| # | 建议 | 说明 |
|---|---|---|
| 1 | **隐私过滤**（最重要） | rsync 是全量同步，tech-vault 里**所有笔记都会被公开**。建议：要发布的放 `tech-vault/blog/` 子目录只同步它；或改用 Quartz Syncer 的 `publish: true` 机制控制单篇；至少给脚本加个 `--dry-run` 预览的习惯 |
| 2 | 脚本加固 | `set -euo pipefail`：任何一步失败立即中止，避免「构建失败但旧产物被 rsync --delete 清掉」；git 改为「有变更才 commit」+ `pull --rebase --autostash`，避免脚本提交在远端落后时卡死 |
| 3 | 失败通知 | 脚本尾部 osascript 通知（已加）；进一步可用 Server 酱/bark 推送到微信 |
| 4 | commit message 带时间 | 便于在 GitHub 上按时间定位每次发布 |
| 5 | 定时 + 手动双模式 | crontab 定时保底，写完手动跑一次立即发布，两者已被脚本锁互斥 |
| 6 | 纯静态资源走 CDN/对象存储 | 流量大了以后，public/ 里的静态资源可推 OSS/COS + CDN，nginx 只兜底 |

---

## 第二部分：一稿多发 + AI 内容生产方案

### 5. 各平台的发布现实

| 平台 | 开放 API | 现实情况 |
|---|---|---|
| 公众号 | 有（素材/草稿箱接口） | 需要已认证账号的 AppID/AppSecret；未认证订阅号权限受限；**发布动作仍需后台人工点** |
| 知乎 | 无公开发文 API | 只能浏览器自动化 |
| 头条号 | 无公开发文 API | 只能浏览器自动化 |
| 掘金/CSDN/博客园等 | 部分有 | 技术社区兼容性好 |

结论：**「全自动一键发布全网」目前不存在合规统一的通道**，主流方案都是「一键同步到**草稿箱** + 人工审核后发布」，这恰好符合你「发布过程需要人工审核」的预期。

### 6. AI 主流工作流：五段流水线

```
① 选题  →  ② 写作  →  ③ 排版适配  →  ④ 一键分发  →  ⑤ 人工审核发布
```

**① 选题（AI 自动抓热点）**

- 数据源：RSSHub（知乎热榜/微博热搜/36kr 等统一转 RSS）、各平台热榜接口、crawl4ai/firecrawl 抓正文
- 用 crontab 每天定时：抓取 → LLM 汇总去重 → 生成「选题日报」markdown，推送到 Obsidian 收件箱或微信
- 你可以在日报里圈选题，剩下的交给 ②

**② 写作（本地 md + AI 初稿）**

- 在 Obsidian 用 Templater 套元信息模板 → AI（WorkBuddy / Claude Code / Cursor）按选题生成初稿，含配图建议
- 人工修改定稿。**这一步是内容质量的总闸，不要省**

**③ 排版适配**

- 公众号富文本：**mdnice / doocs-md**（开源 markdown 转公众号样式，多套主题）
- wechatsync 同步时也会自动做格式转换（Markdown 平台出 Markdown，富文本平台出 HTML，图片自动转存目标平台）

**④ 一键分发（核心工具：wechatsync）**

**文章同步助手（wechatsync）**，开源免费，Chrome 插件，一键同步到 **29+ 平台**：公众号、知乎、头条号、小红书、B 站、掘金、CSDN、博客园、百家号、雪球等。关键能力：

- **草稿模式**：同步后存为各平台草稿，不自动发布 → 天然的人工审核点
- **CLI**：`npm i -g @wechatsync/cli` 后 `wechatsync sync article.md -p zhihu,toutiao,juejin`
- **MCP Server**：可接入 Claude Code / 智能体，对话式触发分发
- 公众号进阶：**wenyan-mcp**（Docker）直接把 md 文章写入公众号**草稿箱**，支持多套排版主题

备选：OpenWrite（商业版，12+ 平台）、n8n 自建工作流（公众号 + 小红书双平台深度改写分发，适合量大的成熟团队）。

**⑤ 人工审核 + 发布 + 归档**

- 逐平台打开草稿，检查排版/封面/摘要（各平台审核规则不同，这步不能省）
- 发布后把各平台链接回写文章 frontmatter，便于追踪数据

### 7. 推荐落地组合（按成本从低到高）

| 阶段 | 组合 | 适合 |
|---|---|---|
| 起步 | Obsidian 写作 + wechatsync 插件手动一键多发 | 每周 1-2 篇 |
| 进阶 | + AI 选题日报（crontab + LLM）+ wenyan-mcp 公众号草稿箱 | 每周 3-5 篇 |
| 重度 | + n8n 工作流：一稿自动改写成公众号长文 + 小红书短文双版本 | 日更/团队 |

与你现有博客工作流的衔接：`tech-vault` 里定稿的博文本来就是 Quartz 站点内容，跑 `deploy-web.sh` 发布博客的同时，用 wechatsync CLI 把同一篇 md 分发到公众号/知乎/头条——**一份 md，五个出口**。

### 8. 风险与合规提醒

- **全自动发布有封号风险**：各平台对机器行为敏感，草稿箱 + 人工点发布是当前安全上限
- **AI 痕迹**：纯 AI 生成直接发，公众号/头条的原创认定和推荐量都会受影响；人工改写 + 实例/数据补充是必需环节
- **热点转载版权**：AI 抓取改写他人内容注意标注来源，避免洗稿判定

---

## 附：本文涉及的工具清单

| 工具 | 用途 | 费用 |
|---|---|---|
| Obsidian + Git / Quartz Syncer / Templater | 写作、同步、模板 | 免费 |
| Quartz v4/v5 | 静态站点生成 | 开源免费 |
| rsync | 笔记同步 + 产物部署 | 系统自带 |
| GitHub Actions | 云端构建部署 Pages | 免费额度 |
| nginx + frp | 本地服务器对外服务 | 开源免费 |
| wechatsync 文章同步助手 | 一键分发 29+ 平台 | 开源免费 |
| wenyan-mcp | 公众号草稿箱自动化 | 开源免费 |
| mdnice / doocs-md | 公众号排版 | 免费 |
| n8n / RSSHub | 工作流编排 / 热榜数据源 | 开源免费 |
