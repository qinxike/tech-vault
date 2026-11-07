git reset vs git restore

## 场景 A：已经 git add （在暂存区），只想取消 add，保留文件内容改动，使用git reset
git add 添加到暂存区后，发现错了，想撤消某个文件或文件夹
git reset HEAD xxx.java
git reset HEAD README.md

## 场景 B：直接扔掉这个文件本地所有改动，恢复成仓库里最新版本
撤消文件内容更改，使用git restore，或git checkout 
### 恢复更改到本地最新版本

- 老写法：
`git checkout HEAD -- README.md`

- Git 2.23+ 新推荐（更易懂）：
```sh
# 恢复一个文件
git restore README.md
# 恢复整个目录
git restore path/to/folder/
```

### 恢复到某个历史版本（不是最新 HEAD）

```sh
# 恢复到 commit abc123 版本的 README.md
git restore --source=abc123 README.md
```

