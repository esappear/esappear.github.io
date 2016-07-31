---
title: git
date: 2016-08-01 01:47:18
tags:
---

学到几个git的新命令

#### 删除远程分支
    $ git push origin :[branch_name]
分支名称前的冒号表示在远程删除该分支
*****
#### 修改远程关联分支
    $ git remote set-url origin [new_repository_address] ([old_repository_address])
*****