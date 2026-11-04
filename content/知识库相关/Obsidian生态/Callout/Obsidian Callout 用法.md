---
publish: true
title: Obsidian Callout 用法
created: 2026-11-03
modified: 2026-11-03
---

# Obsidian Callout 用法（Quartz 也原生支持）

> [!TIP] Callout小技巧
> Callout 是 Obsidian 的扩展语法，属于块提示框，**GFM 原生不支持，但 Quartz 内置解析**，你现在的工作流完全能用。

## 基础模板：

> [!NOTE] 标题（可以省略）
> 这里是内容
> 多行也可以，每行前面加 >

## 内置类型（图标 + 配色）

格式:

```
> [!图标] 标题 
> 内容
```

> [!NOTE] 提示
> 普通备注信息

> [!TIP] 小技巧
> 推荐、有用的技巧

> [!IMPORTANT] 重点
> 需要留意的关键信息

> [!WARNING] 警告
> 风险、注意事项

> [!CAUTION] 危险
> 高危、不可逆操作

> [!QUESTION] 疑问
> 待确认问题

> [!EXAMPLE] 示例
> 代码/案例

> [!QUOTE] 引用
> 摘抄内容

## 两个常用修饰符（放在类型后面）

- `-`：默认折叠（收起） `> [!NOTE]- 可折叠笔记`
- `+`：默认展开 `> [!NOTE]+`（默认本来就是展开，很少写） 示例：

> [!WARNING]- 【风险提醒】批量脚本执行前务必备份库
> 脚本会修改frontmatter，虽然脚本是只补字段不覆盖，但强烈建议先备份！

> [!CAUTION] 注意：
>
> 1. `[!xxx]` 不能有空格，是固定语法；
> 2. 嵌套：callout 里面还可以放列表、代码块、双链；
> 3. 普通 GitHub 直接渲染会变成普通引用块，识别不出样式；**Quartz 没问题**。
