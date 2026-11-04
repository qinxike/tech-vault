---
title: deepseek hardness相关
created: 2026-10-23
modified: 2026-11-02T04:56:31.066Z
publish: true
---

你说现在vscode和Obsidian两个宿主都共享同一份dsh是吗？这份dsh装在npm里，配置在～/.dsh目录是吗？那么桌面版的deepseek harness，用的是另外一份dsh吗？他的配置文件又在哪里？这两个是不是互相独立的？

对，你的理解基本正确，但要区分**代码、运行时、配置、数据**四层。结论是：

- **Obsidian 和 VS Code：完全共用同一份 dsh**（npm 安装的那份），也共用同一个 `~/.dsh` 和同一个 3080 进程。
- **桌面版：代码是另一份**（App 内置），运行时也是内置的 Node 24，端口 50705，profile 是 `desktop`。
- **但两者不是完全独立**：它们共用 `~/.dsh` 里的凭据、会话和存储，只是 profile 和进程分开。

## 一张表看清

|          | Obsidian / VS Code                                                        | 桌面版 DeepSeek Harness                                                               |
| -------- | ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| dsh 代码   | npm 全局包：`~/.nvm/versions/node/v22.23.4/lib/node_modules/@deepseek-ai/dsh` | App 内置：`/Applications/DeepSeek Harness.app/Contents/Resources/app.asar`（`dsh/` 目录） |
| 启动命令     | `~/.nvm/versions/node/v22.23.4/bin/dsh`                                   | App 主进程内启动，不经过系统 `dsh`                                                             |
| Node 运行时 | 系统 nvm 的 **v22.23.4**                                                     | App 内置 **Node 24.21.0**（Electron 以 Node 模式运行）                                      |
| DSH\_HOME | `~/.dsh`                                                                  | `~/.dsh`（同一个）                                                                      |
| profile  | `web` → `~/.dsh/profiles/web/`                                            | `desktop` → `~/.dsh/profiles/desktop/`                                             |
| 监听端口     | **3080**（Obsidian 和 VS Code 共用）                                           | **50705**（当前实例，动态分配）                                                               |
| 版本       | 0.2.1-rc.2                                                                | 0.2.1-rc.2                                                                         |
| 升级方式     | `npm install -g @deepseek-ai/dsh`                                         | App 自动更新 / 重装 App                                                                  |

## 哪些是共享的

共享（都在 `~/.dsh` 下）：

- `~/.dsh/.credentials.yaml` —— 登录凭据/API key，一处改了另一处也变
- `~/.dsh/sessions/` —— 会话记录，**按工作区路径分目录，不按 profile 分**
- `~/.dsh/storages/` —— workspace 注册表、会话缓存
- `~/.dsh/.anonymous-user-id`

所以：如果你在桌面版和 VS Code 里打开**同一个工作区**，它们会看到同一批 session；同时编辑同一个会话理论上会有写竞争，建议别两边同时操作同一个会话。

不共享：

- **profile 配置**：`web` 和 `desktop` 各自有 `cordis.patch.yml`、`package.json`。web 里装的 `dsh-drop-caret`、`dsh-vscode-file-links`、`dsh-obsidian-bridge` 不会出现在桌面版。
- **进程**：桌面版跑在自己的 Electron 进程里，CLI 版本跑在独立 `node` 进程里，互不影响。
- **代码和运行时**：升级 npm 的 dsh 不会升级桌面版；桌面 App 更新也不会动 npm 那份。
