---
title: PostgreSql安装使用
description: ""
tags: []
created: 2026-11-06T21:36:37+08:00
modified: 2026-11-06T21:36:37+08:00
draft: false
publish: true
---
# PostgreSql安装

## 安装
`brew install postgresql@17`
brew方式安装，默认超级用户名是当前系统用户名:qinxike，而不是内置的用户名:postgres
默认超级用户：qinxike
默认数据库：postgres(内置)

## 首次连接，修改密码
超级用户首先要登录默认数据库，才可以进行相关操作:
```shell
# 初次登录，默认本地免密进入。可修改/opt/homebrew/var/postgresql@17/pg_hba.conf
# 不指定-h，则默认为登录到local
psql -U qinxike postgres
# 命令行修改密码
\password
# sql脚本修改密码
ALTER USER qinxike WITH PASSWORD 'xxxxxxx';
```

## 修改登录方式
默认本地免密登录，远程无法登录。
找到配置文件路径: 
- postgresql.conf 主要配置
    vi /opt/homebrew/var/postgresql@17/postgresql.conf

```
监听IP地址，默认只监听本机，远程无法连接 
listen_addresses = '*'
# 默认端口
port = 5432       # (change requires restart) 
```

-  pg_hba.conf 登录权限配置
vi /opt/homebrew/var/postgresql@17/pg_hba.conf

```
# 把`trust` 改成 `scram-sha-256`，IP地址根据需要修改

# 127.0.0.1登录，需要密码
host    all             all             127.0.0.1/32          scram-sha-256
# 允许远程登录，需要密码
host    all             all             0.0.0.0/0             scram-sha-256
```

- 重载配置，不用重启

```
psql -c "SELECT pg_reload_conf();"
```

- 之后用 tcp 方式连接就需要密码：

```
psql -h 127.0.0.1 -U qinxike -d postgres
```

### 客户端连接
jdbc:postgresql://192.168.31.36:5432/dazi
用户:  user_dazi/xxxxxx

