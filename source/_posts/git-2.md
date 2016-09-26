---
title: git merge与git rebase
date: 2016-09-26 16:45:22
tags: [git]
---
[别人的小结](http://blog.csdn.net/wh_19910525/article/details/7554489)

共同目的：合并分支

`git merge`: 被merge的分支内容以新的commit合并到当前分支，`git merge <commit1> [<commit2>]` commit2默认为当前分支。

`git rebase`: 先把当前分支较两个分支的最新共同commit的修改保存起来，然后重新确定根commit（被rebase的最新commit即新的跟commit），再之前保存起的修改内容以备份的形式合并到当前分支。

`git merge-base <commit1> <commit2>`: 找两个分支/commit 间最新的共同commit


