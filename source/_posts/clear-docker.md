---
title: 一键清理没用的docker容器 
date: 2018-06-19 14:07:45
tags: [shell, docker]
---
```bash
docker ps -a | grep Exited | cut -d ' ' -f 1 | xargs docker rm
```
- 管道是个好东西
- cut 是个好东西
- xargs是个好东西
- docker是个好东西

同样的方法可以清掉没用的git 分支
```bash
git br -vv | grep gone | cut -d ' ' -f 3 | xargs git br -d
```
