---
publish: true
title: Frontmatter文件元信息模板
created: 2026-11-02
modified: 2026-11-02T17:29:31.713Z
---

# 文件元信息模板 Frontmatter Templater

### 相关插件

- **Templater + Dataview**：写模板，新建笔记自动带上；
  批量给存量笔记补 `date、tags、draft:false` 示例 Templater 模板：
- **Metadata Menu**：设置模板，一键给选中笔记插入 frontmatter 模板

## 设置模板

### Templater模板

新建一个模板md文件，在插件设置中，选择模板文件指向该文件

```
---
title: <% tp.file.title %>
date: <% tp.file.creation_date("YYYY-MM-DD") %>
tags: []
draft: false
---
```
