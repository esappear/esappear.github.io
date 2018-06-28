---
title: 终于可以自动化部署了
date: 2016-08-02 00:56:16
tags: [HEXO, Github, travis]
---
终于用travis搞定自动化部署了,开心~
*****
这个教程比较靠谱: [用 Travis CI 自动部署 hexo](https://segmentfault.com/a/1190000004667156)
### 这可能是坑
1.创建SHH key: 为项目创建deploy-key的时候千万别把本地之前的key给覆盖了,下面的命令是可以重命名的.
    ```bash
    $ ssh-keygen -t rsa -C "youremail@example.com"
    ```
2.创建key的时候千万不要设置passphrase,不然就等着它失败吧,因为根本没有地方可以让你输入密码...
3.据说hexo的配置文件_config.yml里的repo要用git,而不是https.
    ``` bash
    deploy:
      type: git
      repo: git@github.com:chengjianhua/chengjianhua.github.io.git
      branch: master
    ```
*****
算了,不熬夜伤神了~
本文纯属劫后马克一记.
