---
title: 使用HEXO和Github搭建博客有感
date: 2016-07-31 15:57:26
tags: [HEXO, Github, Travis CI, CI, 总结]
---

总算用HEXO和Github成功的构建了博客，并用`Travis CI`实现了自动部署。

参考文章：
- [HEXO+Github,搭建属于自己的博客](http://www.jianshu.com/p/465830080ea9)
- [史上最新版GitHub+Hexo配置系列教程](http://blog.csdn.net/SmallCheric/article/details/51049691)
- [用 Travis CI 自动部署 hexo](https://segmentfault.com/a/1190000004667156)

重新整理下流程：
# 生成HEXO项目
```bash
npm install hexo-cli -g 
hexo init [project_name]
cd [project_name]
npm install
hexo server
```
## 配置主题
参考[NexT.Mist](https://github.com/iissnan/hexo-theme-next)

# 部署到GitHub
## 建立Github项目
项目名称应为[user_name.github.io]
## 安装`hexo-deployer-git`
```bash
npm install hexo-deployer-git --save
```
## 配置`_config.yml`
```bash
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repo: https://github.com/[user_name]/[user_name].github.io.git
  branch: master
```

# 利用`Travis CI`实现自动化部署
## 开启`Travis CI`，并将对应的项目状态开启
## 生成公钥
```bash
ssh-keygen -t rsa -C "youremail@example.com" # 生成id_rsa.pub和id_rsa
```
## 将`id_rsa.pub`添加到GitHub项目的Deploy key中，并将`Allow write access`打开
## 加密私钥
```bash
mkdir .travis
gem install travis # 安装 cli
travis login --auto # 登录
travis encrypt-file id_rsa --add # id_rsa为刚生成的密钥文件，这会在当前目录生成加密后的私钥文件id_rsa.enc，同时会输入encrypted_key 和 encrypted_iv
```
## 添加`ssh_config`
```bash
Host github.com
    User git
    StrictHostKeyChecking no
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
```
放在`.travis`目录中
## 配置`_travis.yml`
```yml
# 声明语言和版本
language: node_js
node_js:
  - "7" 
# 指定分支
branches:
  only:
  - pages-origin
# 添加缓存
cache:
  directories:
  - node_modules

before_install:
# 解密私钥文件，并放到~/.ssh目录中
- openssl aes-256-cbc -K $encrypted_xxxxxx_key -iv $encrypted_xxxx2548ca7ff03a_iv
  -in .travis/id_rsa.enc -out ~/.ssh/id_rsa -d
# 改变文件权限
- chmod 600 ~/.ssh/id_rsa
# 配置ssh
- eval $(ssh-agent)
- ssh-add ~/.ssh/id_rsa
- cp .travis/ssh_config ~/.ssh/config
# 配置git账号
- git config --global user.name xxx
- git config --global user.email xxxx

install:
- npm install

# 生成博客
script:
- ./node_modules/hexo/bin/hexo clean
- ./node_modules/hexo/bin/hexo g
# 部署
after_success:
- ./node_modules/hexo/bin/hexo d
```