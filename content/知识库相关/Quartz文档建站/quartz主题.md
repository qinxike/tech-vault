---
publish: true
title: quartz主题
created: 2026-11-04
modified: 2026-11-04
---

# ✅ Quartz 第三方主题站点 + 推荐模板（适配 Quartz 5)

## 🔗 主题预览网站（优先看这个）https://quartz-themes.github.io/

- 仓库地址：<https://github.com/saberzero1/quartz-themes>
- 每个主题都有在线预览页，点进去直接看效果，附带安装命令

> 这是 saberzero1 维护的社区主题合集，是目前 Quartz 生态最成熟的主题仓库，全部是从 Obsidian 热门主题移植过来，支持明暗双模式，开箱即用，和 Quartz Syncer 完美兼容

## [Installation](https://github.com/saberzero1/quartz-themes/tree/master#installation)

### [npm package (Recommended)](https://github.com/saberzero1/quartz-themes/tree/master#npm-package-recommended)

安装主题核心插件和你选择的主题插件:

```shell
npm install @quartz-themes/core @quartz-themes/<THEME-NAME>
```

修改配置文件主题相关部分`quartz.config.yaml`:

```yaml
plugins:
  - source: "@quartz-themes/core"
    options:
      theme: "<THEME-NAME>"
      mode: "both"
```

> [!Tip]
> Example for Tokyo Night:
>
> ```shell
> npm install @quartz-themes/core @quartz-themes/tokyo-night
> ```
>
> ```yaml
> plugins:
>  - source: "@quartz-themes/core"
>   options:
>      theme: "tokyo-night"
>      mode: "both"
> ```

## 🎨 推荐给你的几套风格模板（按你的知识库场景挑选）

> 你的知识库：knowledge-vault，分 tech /life/hobby /biz，偏技术笔记、文档、数字花园，优先选阅读舒服、callout 好看、代码块美观的

### 1. Catppuccin（首推！温柔多配色，明暗都好看）

预览：<https://quartz-themes.github.io/catppuccin> 特点：4 种子色调（Mocha / Macchiato / Frappe / Latte），柔和低饱和，代码高亮非常舒服，callout 玻璃质感，技术文档、笔记最适配，很多人用这个做知识库

```
npm install @quartz-themes/core @quartz-themes/catppuccin
```

quartz.config.yaml 主题配置：

```
plugins:
  - source: "@quartz-themes/core"
    options:
      theme: "catppuccin"
      variation: "mocha" # mocha深色，latte浅色
      mode: "both"
      fontOrigin: "local"
```

> [!TIP]
> 国内网络：
> Google 字体加载会慢！在主题配置里把 `fontOrigin: local`，字体本地打包，避免卡住
>
> ```
> options:
> theme: "catppuccin"
>   ...
>  fontOrigin: "local"
> ```

### 2. Tokyo Night（程序员深色经典，干净利落）

预览：<https://quartz-themes.github.io/tokyo-night> 特点：日系深蓝深色主题，浅色模式清爽，代码高亮辨识度高，适合 tech-vault 技术笔记，极简不花哨

### 3. Dracula（德古拉，经典深色）

预览：<https://quartz-themes.github.io/dracula-official> 特点：高对比度深色，适合晚上阅读，适合放代码、技术文档；浅色模式比较普通，适合只长期开深色的人

### 4. Zen Forest（森系简约，文艺向，life/hobby 知识库）

预览：<https://quartz-themes.github.io/zen-forest> 特点：低饱和绿调，柔和护眼，适合生活、爱好随笔，氛围感数字花园，明暗双模式

### 5. Simple（极致极简，几乎无多余装饰）✅ 清新推荐

预览：<https://quartz-themes.github.io/simple> 特点：纯白背景、无花哨装饰，字体干净，追求 “内容优先”，适合严肃商业 biz-vault、行业文档，加载速度最快

### 6. Emerald（翠绿色系，清新）✅ 清新推荐

预览：<https://quartz-themes.github.io/emerald> 适合生活、教育类笔记，柔和护眼，不刺眼npm

```
npm install @quartz-themes/core @quartz-themes/emerald
```

quartz.config.yaml 配置：

```
plugins:
  - source: "@quartz-themes/core"
    options:
      theme: "emerald"
      variation: "latte" # mocha深色，latte浅色
      mode: "both"xx
```

# ✅ 专门移植自 Obsidian 的 Quartz 主题（quartz-themes 仓库，v5 可用）

预览总站：<https://quartz-themes.github.io/> 里面大量主题都是 Obsidian 社区热门主题直接移植到 Quartz 的，**callout、排版、代码块、配色和你 Obsidian 里面一模一样**

## 🔥 优先推荐 3 个最贴近 Obsidian 原生风格

### 1. Obuntu（最接近 Obsidian 默认原生！首选）

预览：<https://quartz-themes.github.io/obuntu>

- 移植源：Obsidian 默认主题（Obsidian Default）
- 特点：字体、留白、callout 样式、明暗色都和 Obsidian 打开几乎一样，没有花哨改造，**你想要的 “打开网站和我 Obsidian 看笔记感觉一致” 就是它**
- 安装：

```
npm install @quartz-themes/core @quartz-themes/obuntu
```

quartz.config.yaml 配置：

```
plugins:
  - source: "@quartz-themes/core"
    options:
      theme: "obuntu"
      mode: "both"
      fontOrigin: "local" # 本地字体，国内加载快
```

### 2. Minimal（Obsidian 最火极简主题，很多人用）

Obsidian Minimal 移植版，干净紧凑、侧边栏简约，适合 tech-vault、biz-vault 技术 / 商业文档

> 仓库里关键词 `minimal`

### 3. Its Theme（Its 经典 Obsidian 主题，多变种）

预览：<https://quartz-themes.github.io/its-theme>

- 有 gray /minimalist/its-dark 多个变体，柔和低对比，护眼，适合长期阅读笔记

```
npm install @quartz-themes/core @quartz-themes/its-theme
```

quartz.config.yaml 配置：

```
plugins:
  - source: "@quartz-themes/core"
    options:
      theme: "its-theme"
      variation: "minimalist"
      mode: "both"
```

### 其他热门 Obsidian 移植主题（你之前听过的）

- Catppuccin：Obsidian 爆款，柔和多配色（你之前看过）
- Tokyo Night：Obsidian 深色热门
- Rose Pine、Kanagawa：都是 Obsidian 老牌主题移植

## 📌 方案 B：不装主题插件，自己写 CSS，复刻 Obsidian 原生（自由度最高）

如果你只要**Obsidian 默认浅色/深色**，不想装 npm 插件，直接写进 `quartz/styles/custom.scss`，不会被 quartz 升级覆盖：

```
// 复刻Obsidian原生配色、圆角、callout
:root {
  --bg: #ffffff;
  --text: #2e3440;
  --accent: #4078c0;
  --radius: 4px; // Obsidian原生小圆角
  --callout-bg: #f6f8fa;
}
.dark {
  --bg: #1e1e1e;
  --text: #dcdcdc;
  --callout-bg: #252526;
}
.callout {
  border-radius: var(--radius);
  border-left: 4px solid var(--accent);
  background: var(--callout-bg);
}
```

> 缺点：graph、侧边栏组件样式需要自己一点点调；优点：零依赖、轻量。

## ⚠️ 重要避坑（结合你的工作流）

1. 全部是 **Quartz 5 专用**，你现在版本正好适配；
2. 只改样式，**不改动你的 md、callout 语法、frontmatter**，rsync 同步脚本完全不用改；
3. 一次只能启用一个主题，不要同时加载多个；
4. `fontOrigin: local` 一定要加上，避免 Google 字体国内打不开；
5. 移植主题**不会 100% 像素一模一样**：Obsidian 是桌面端，Quartz 是网页，组件（侧边栏、图床、回链面板）底层结构不一样，排版观感接近原生，不是完全复刻。
