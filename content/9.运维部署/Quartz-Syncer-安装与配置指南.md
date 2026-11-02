---
publish: true
title: Obsidian Quartz Syncer 安装与配置指南
description: 从零把 Obsidian 笔记发布成 Quartz 静态网站的完整步骤（GitHub 版）
created: 2026-11-01
modified: 2026-11-02T04:48:15.197Z
tags:
  - obsidian
  - quartz
  - 建站
  - 发布
---

# Obsidian Quartz Syncer 安装与配置指南

> 目标：把 Obsidian 知识库中的笔记，通过 Quartz Syncer 插件发布成静态网站，托管在 GitHub Pages。
> 适用环境：macOS + Obsidian 1.14+ + Quartz v5。
> 本机实测：Node v23.6.1 / npm 10.9.2 / git 2.39.5，无需额外安装 Quartz。

---

## 一、先搞清楚三者的关系

| 角色 | 是什么 | 需要你操心吗 |
|---|---|---|
| Obsidian 知识库（vault） | 你写笔记的地方，如 `~/works/knowledge-vault/hobby-vault` | 只管写 |
| Quartz 仓库 | GitHub 上一个**整站项目**，`content/` 才是网站内容，其余是构建源码 | 建一次，之后基本不管 |
| Quartz Syncer 插件 | 把笔记通过 GitHub API 提交进仓库 `content/` | 日常唯一操作入口 |

发布链路：

```
Obsidian 笔记 --(插件通过 GitHub API 提交)--> 仓库 content/ --(push 触发)--> GitHub Actions 构建 --> 你的用户名.github.io
```

关键认知：

- **只发布带 `publish: true` 的笔记**，其余笔记不会被带走
- **单向同步**：不要直接在 GitHub 网页改 `content/` 里的文件，下次发布会被覆盖
- 构建在 GitHub 云端跑，**本机不需要装 Quartz、不需要装 Node**

---

## 二、创建 GitHub 仓库

1. 打开 <https://github.com/jackyzha0/quartz>
2. 点 **Use this template → Create a new repository**
3. 仓库名随意，如 `quartz-site`
4. **务必勾选 `Include all branches`**（否则 v4/v5 分支缺失，插件配置分支时会 404/401）
5. Create repository

建好后仓库地址形如：

```
https://github.com/你的用户名/quartz-site.git
```

> 备选路线：模板 README 里的 "Deploy to Vercel" 按钮，会自动 fork 一份到你的账号并部署，不用配 Pages。两条路选一条即可。

---

## 三、生成 GitHub 访问令牌（Token）

打开 GitHub → 头像 → **Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token**

| 设置项 | 填写内容 |
|---|---|
| Token name | `quartz-syncer` |
| Expiration | 按需（fine-grained 最长 1 年，到期需重签） |
| Repository access | **Only select repositories** → 选中刚才建的 quartz 仓库 |
| Permissions → Contents | **Read and write** |
| Permissions → Pull requests | **Read and write**（部分版本要求） |

点 **Generate token**，**立刻复制**（页面只显示一次，离开就看不到了）。

---

## 四、在 Obsidian 中安装插件

1. Obsidian → 设置 → **第三方插件** → 关闭安全模式 → 浏览
2. 搜索 **Quartz Syncer** → 安装 → 启用
3. 左侧设置列表出现 **Quartz Syncer**，其下还有 **Quartz**（Quartz Hub）配置项

---

## 五、配置 Git 连接（核心，401 多半出在这里）

设置 → **Quartz Syncer** → **Git** 标签页：

| 设置项 | 填写内容 |
|---|---|
| Remote URL | `https://github.com/你的用户名/quartz-site.git` |
| Branch | 仓库默认分支：v5 模板填 `v5`，v4 模板填 `v4` 或 `main` |
| Provider | `GitHub` |
| Authentication Type | `Username & Token/Password` |
| Username | 你的 GitHub 用户名（注意大小写） |
| Access Token | 粘贴第三步的 token |

点 **Save**，出现 **绿色对勾 ✅** 表示连接成功。

### 401 排查清单（按命中率排序）

| 现象 | 原因 | 处理 |
|---|---|---|
| `HTTP Error: 401` | token 过期 | 去 GitHub 看是否 Expired，重新生成 |
| `HTTP Error: 401` | token 授权的仓库不是这一个 | fine-grained token 只对勾选的仓库生效 |
| `HTTP Error: 401` | token 复制不全 / 带空格 | 重新完整复制 |
| `HTTP Error: 401` | 用户名或 Remote URL 拼错 | 逐字符核对 |
| `HTTP Error: 401` | 代理劫持了请求 | 确保 Obsidian 也走代理（系统代理或 `https_proxy`） |
| `HTTP Error: 404` | 仓库或分支不存在 | 检查是否勾了 Include all branches、分支名是否写错 |

---

## 六、链接本地仓库（Quartz Hub，可选但推荐）

用途：让 Config / Layout / Templates 面板能直接改站点配置，也方便本地预览。

⚠️ **本地仓库必须放在 Obsidian 知识库外面**，否则整个 Quartz 源码会被灌进笔记库。

设置 → **Quartz** → **Setup** 标签页：

**CLONE FROM REMOTE：**

| 设置项 | 填写内容 |
|---|---|
| Remote URL | `https://github.com/你的用户名/quartz-site.git` |
| Destination folder | `/Users/qinxike/works/quartz-site`（vault 外的新目录） |

点 **Clone**。

**LINK EXISTING REPOSITORY：**

| 设置项 | 填写内容 |
|---|---|
| Repository path | `/Users/qinxike/works/quartz-site` |

点 **Link**。

推荐目录布局：

```
~/works/
├── knowledge-vault/        # Obsidian 知识库，原样不动
│   ├── dev-vault/
│   ├── tech-vault/
│   ├── life-vault/
│   ├── hobby-vault/        # 发布源
│   └── biz-vault/
└── quartz-site/            # Quartz 仓库，独立目录
```

---

## 七、修改站点基本配置

在 Quartz Hub 的 **Config** 标签页（或直接编辑仓库里的 `quartz.config.yaml`）：

| 字段 | 说明 | 示例 |
|---|---|---|
| `pageTitle` | 网站标题 | `我的知识花园` |
| `baseUrl` | **关键**，填错会导致样式/链接全挂 | `你的用户名.github.io` |

v4 对应文件是 `quartz.config.ts` 里的 `configuration.baseUrl`。填完提交（插件会自动同步到仓库）。

---

## 八、开启 GitHub Pages 自动部署

1. 仓库 → **Settings → Pages**
2. **Source** 选 **GitHub Actions**
3. 确认仓库里存在 `.github/workflows/deploy.yml`（官方模板自带）

之后每次 `content/` 有提交，Actions 会自动构建，几分钟后站点更新。可在仓库 **Actions** 标签页看构建日志。

---

## 九、发布第一篇笔记

1. 在要发布的笔记 frontmatter 里加：

```yaml
---
title: Hobby Vault
description: 各类兴趣爱好、技能练习与生活趣味专题笔记
publish: true
---
```

2. 命令面板（`Cmd+P`）→ **Quartz Syncer: Open publication center**，或点侧边栏叶子图标
3. Publication Center 里笔记分四类：

| 分类 | 含义 | 操作 |
|---|---|---|
| Unpublished notes | 本地有、仓库没有 | 勾选 → 发布 |
| Changed notes | 两边不一致 | 勾选 → 更新（可看 diff） |
| Published notes | 已发布 | 勾选 → 取消发布并从仓库移除 |
| Unchanged notes | 两边一致 | 无需操作 |

4. 勾选后点 **PUBLISH SELECTED CHANGES**

> 每次发布通常产生 **2 次 commit**：一次新增/更新，一次移除取消发布的笔记。这是插件刻意设计，正常现象。

---

## 十、多知识库场景：只发布其中一个子库

知识库结构是「一个 vault 含多个子库」时，插件默认把**整个 vault** 都当发布内容，需要限定范围：

设置 → Quartz Syncer → **Vault root folder name** → 填子库文件夹名，如 `hobby-vault`

效果：

- 该文件夹成为网站根目录，内部链接自动去掉路径前缀
- 文件夹里的 `index.md` 变成网站首页 → **记得在这个文件夹里放 `index.md` 并加 `publish: true`**

---

## 十一、日常速查

| 我要做什么 | 怎么做 |
|---|---|
| 发布新笔记 | 加 `publish: true` → Publication Center → 勾选 → Publish |
| 修改已发布笔记 | 保存后 Publication Center 会出现在 Changed，勾选更新 |
| 下线一篇笔记 | Publication Center → Published 里勾选 → Publish（会从仓库删除） |
| 本地删除的笔记想同步删掉 | 必须在 Publication Center 里勾选取消发布，才会从仓库移除 |
| 看站点构建失败原因 | GitHub 仓库 → Actions → 最近一次 run 日志 |
| 换 token | Quartz Syncer → Git → 更新 Access Token → Save |

---

## 十二、附录：本地预览（可选）

需要调样式（`custom.scss`）、改 layout 时才用得上：

```bash
cd ~/works/quartz-site
git pull
npm ci
npx quartz plugin install    # v5 必须，否则 build 失败
npx quartz build --serve     # 打开 http://localhost:8080
```

注意：

- Quartz **不是全局 CLI**，没有 `npm i -g quartz` 这回事
- v5 要求 Node ≥ 22、npm ≥ 10.9.2；本机 npm 10.9.2 正好卡线，报版本错时执行 `nvm use 22 && npm i -g npm@latest`
- 本机 Node 有多份（Homebrew 23.6.1 / nvm 22.23.4），本地构建建议统一到 LTS

---

## 附：本次配置的实际参数（备查）

| 项目 | 值 |
|---|---|
| Obsidian 版本 | 1.14.5 |
| 知识库 | `~/works/knowledge-vault` |
| 发布源子库 | `hobby-vault` → `~/works/knowledge-vault/爱好知识库` |
| 本地 Quartz 仓库 | `~/works/quartz-site`（计划） |
| 插件 | Quartz Syncer（含 Quartz Hub 配置面板） |
| 本机环境 | macOS / Node v23.6.1 / npm 10.9.2 / git 2.39.5 |
