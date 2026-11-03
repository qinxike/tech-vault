## quartz介绍


https://github.com/Muliminty/Muliminty-Note/blob/master/07-%E5%9F%BA%E7%A1%80%E8%AE%BE%E6%96%BD%E4%B8%8E%E8%BF%90%E7%BB%B4/05-%E9%9D%99%E6%80%81%E7%BD%91%E7%AB%99%E9%83%A8%E7%BD%B2/Quartz%20%E5%AE%9A%E5%88%B6%E6%95%99%E7%A8%8B.md

## 目录结构
 ```
项目根目录/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions 部署配置
├── content/                    # 笔记内容目录（软链到真正的md文档目录）
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

## 构建部署步骤
1. git创建仓库
2. 本地安装quartz,
3. 