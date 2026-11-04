---
title: quartz文档网站构建
description: ""
created: 2026-11-04
modified: 2026-11-04
draft: false
publish: true
---

# [quartz介绍](https://github.com/Muliminty/Muliminty-Note/blob/master/07-%E5%9F%BA%E7%A1%80%E8%AE%BE%E6%96%BD%E4%B8%8E%E8%BF%90%E7%BB%B4/05-%E9%9D%99%E6%8    0%81%E7%BD%91%E7%AB%99%E9%83%A8%E7%BD%B2/Quartz%20%E5%AE%9A%E5%88%B6%E6%95%99%E7%A8%8B.md)

## 目录结构

```
项目根目录/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions 部署配置
├── content/                    # 笔记内容目录（同步真正的md文档目录）
├── public/                     # 构建输出目录
├── quartz/                     # Quartz 核心文件（自动生成）
│   ├── cfg.ts                  # 配置类型定义
│   ├── components.ts           # 组件定义
│   └── plugins.ts             # 插件定义
├── quartz.config.ts            # Quartz 主配置文件
├── quartz.layout.ts            # 布局配置文件
├── package.json                # 项目依赖
├── .gitignore                  # Git 忽略文件
└── README.md                   # 项目说明
```

# 完整标准流程串一遍（适配你现在的工作流）

1. Github 新建空白仓库 `tech-vault-site`，拿到仓库地址，
    如: https://github.com/qinxike/tech-vault-site.git
2. 拉官方模板：

```
git clone https://github.com/jackyzha0/quartz.git tech-vault-site
cd tech-vault-site
```

3. 替换远程为你自己的仓库

```
# 进入目录
cd tech-vault-site
# 删掉原来指向官方quartz的远程origin
git remote remove origin
# 绑定成【你自己的远程仓库】
git remote add origin https://github.com/qinxike/tech-vault-site.git
```

- (可选)本地克隆官方模板之后，保留官方上游（upstream）

> 把官方quartz模板存为名叫 upstream 的远程，用于后续更新
```
git remote add upstream https://github.com/jackyzha0/quartz.git
# 以后想要升级 Quartz版本
git fetch upstream
git merge upstream/v5
```

4. 安装依赖

```
pnpm install
```

5. 配置 quartz.config.ts、准备同步脚本、rsync 把真正的笔记同步进 `content`目录
6. 本地预览：
   `npx quartz build --serve`
   `pnpm exec quartz build --serve`
7. 确认没问题，提交推送到**你自己的仓库**

```
git add .
git commit -m "init quartz site + sync notes"
git push -u origin main
```

8. 再配置 GitHub Action 自动部署（Action 跑在**你的仓库**）

---

# 补充一个容易混淆的点

很多新手会误以为：
> 我 fork 原作者仓库，然后 clone fork 后的仓库
