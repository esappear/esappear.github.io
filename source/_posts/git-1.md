---
title: git 常用命令整理
date: 2016-09-26 16:38:04
tags: [git]
---

阮一峰整理的[常用git命令](http://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)

一张关于git原理的示意图
![git原理图](http://ww2.sinaimg.cn/large/675f4a91jw1f0wq3jnh5bj20wk09gjsy.jpg)

#### 几个基本概念
	Workspace：工作区
	Index / Stage：暂存区
	Repository：仓库区（或本地仓库）
	Remote：远程仓库
	
#### 个人常用的命令
[]为可选项，<>为必需项
##### 初始化
```bash
$ git init [project_name]
$ git clone <url>
```
##### 配置
配置文件.gitconfig

```bash
# 显示当前的Git配置
$ git config --list

# 编辑Git配置文件
$ git config -e [--global]

# 设置提交代码时的用户信息
$ git config [--global] user.name "<name>"
$ git config [--global] user.email "<email address>"
```
##### 代码提交
```bash
# 提交工作区自上次commit之后的变化，直接到仓库区
# 等效于 git add . && git commit
$ git commit -a

# 使用一次新的commit，替代上一次提交
# 如果代码没有任何新变化，则用来改写上一次commit的提交信息
# 可以指定file
$ git commit --amend -m [message] [file]
```
##### 分支
```bash
# 列出所有远程分支
$ git branch -r

# 列出所有本地分支和远程分支
$ git branch -a

# 选择一个commit，合并进当前分支
$ git cherry-pick [commit]

# 删除远程分支
$ git push origin --delete <branch-name>
$ git branch -dr <remote> <branch-name>
```
##### 标签
```bash
# 新建一个tag在指定commit
$ git tag <tag> [commit]

# 提交指定tag
$ git push [remote] [tag]

# 提交所有tag
$ git push [remote] --tags
```

##### 查看信息
```bash
# 显示某个文件的版本历史，包括文件改名
$ git log --follow [file]
$ git whatchanged [file]

# 显示指定文件相关的每一次diff
$ git log -p [file]

# 显示指定文件是什么人在什么时间修改过
$ git blame [file]

# 显示某次提交发生变化的文件
$ git show --name-only [commit]

# 显示某次提交时，某个文件的内容
$ git show [commit]:[filename]
```

##### 远程同步
```bash
# 下载远程仓库的所有变动
$ git fetch [remote]

# 显示某个远程仓库的信息
$ git remote show [remote]

# 增加一个新的远程仓库，并命名
$ git remote add [shortname] [url]
```

##### 撤销
```bash
# 恢复上一个commit的所有文件到工作区
$ git checkout .

# 重置当前HEAD为指定commit，但保持暂存区和工作区不变
$ git reset --keep [commit]

# 新建一个commit，用来撤销指定commit
# 后者的所有变化都将被前者抵消，并且应用到当前分支
$ git revert [commit]
```
