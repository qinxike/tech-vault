---
publish: true
title: quartz meta属性
created: 2026-11-02
modified: 2026-11-02T17:16:44.301Z
---

## Frontmatter（文件头元信息）自动机制

分两层讲清楚：

### ① Quartz 内部：**自动读取、自动兜底，但【不写入 md】**

官方原生规则：

- 如果你**不写 frontmatter**，Quartz自动处理:
  - `title`：自动拿文件名当页面标题
  - `description`：没有，SEO 预览就空
  - `tags`：无
  - `draft`：默认 `false`（非草稿可发布）
    👉 **这个是「读取时自动生成页面元数据」，不是写到 md 文件头部，你的源文件干干净净，零侵入！**
    也就是说：**你完全可以一篇 frontmatter 都不写，直接 build 跑站**，只是缺少描述、自定义标签、草稿控制这些能力。
- publish : 默认false，默认不生成页面不发布
属性介绍:

- `draft: true`: 视为草稿。不会生成页面，Quartz 不会发布；
- `publish: false`: 不会生成页面，Quartz 不会发布（新版 quartz 优先 draft）

### ② 你想要的：批量自动往 md 头部补 --- frontmatter（解决一个个写麻烦）

Quartz**没有内置这个写入功能**，两个成熟方案（Obsidian 工作流首选方案 A）

#### 方案 A：Obsidian 插件自动生成（最稳，不折腾脚本）

1. **Metadata Menu**：设置模板，一键给选中笔记插入 frontmatter 模板
2. **Templater + Dataview**：写模板，新建笔记自动带上；批量给存量笔记补 `date、tags、draft:false` 示例 Templater 模板：

```
---
title: <% tp.file.title %>
description: 
date: <% tp.file.creation_date("YYYY-MM-DD") %>
tags: []
draft: false
publish: true
---
```

> 优点：在 Obsidian 里操作，源库统一管理，双链、属性面板同步生效，和 Quartz 完美兼容

## 三、工作流推荐

```
Obsidian库（原始md，日常写笔记）
    ↓
映射content目录
    ↓
windows: mklink /J 把【待发布子文件夹】映射到 quartz/content
mac: ln -s 把【待发布子文件夹】映射到 quartz/content

Quartz构建:
npx quartz build --serve
```
