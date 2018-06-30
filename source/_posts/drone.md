---
title: 记一次使用drone持续集成的经历
date: 2017-09-09 09:54:44
tags: [drone, 持续集成, CI, 持续交付]
---
前段时间一直在整一个angular 1.xx版本的UI项目，从项目建立，支持上传CDN，开发过程持续热更新，可持续生成文档，到利用drone实现自动化上传CDN、生成文档、并部署到GitHub的gh-page上，这一路也算是折腾艰辛，不过也感觉一下子收获了很多经验值。

整个构建过程还是主要用gulp写的，期间用了很多的各种插件，包括但不限于：
- browser-sync 绝对的持续热更新的利器，而且还可以多个端同步。多个端同时打开一个页面，任何交互都会同步。
- marked markdown转HTML
- rainbow.js 让代码在HTML中语法高亮起来
- gulp-template 模板替换，在生成demo的模板文件的时候用到。
- gulp-tap 在pipeline中做一些其他事情，如另外读取文件、去掉注释、markdown转成HTML等
- gulp-header 在文件头部加上header，使得生成出来的文件有逼格
- gulp-upyun、gulp-eslint、gulp-rename、gulp-cssnano、gulp-uglify等看到名字就知道能干嘛的插件

当然这次项目的挑战性还是在持续集成上，虽然之前折腾过用`Travis CI`自动化部署个人博客，但这次还是蛋疼了一段时间，主要点在要将生成的文档这一堆静态文件部署到gh-page上。因为这次的项目是放在公司自己搭建的git服务器上的，但是公司的git服务不支持gh-page, 想要像`https://qingchengfed.github.io/angular-clover-ui/`这样轻松的访问该项目的文档不太现实。而且这个项目的文档是有脚本的，是要用到angular的，所以gitbook也不能满足要求。

在尝试过多种方法后，最终还是采用了在项目下建个临时文件夹，拉下指定的仓库后，生成commit后强制push到远程的方法。

```
# .drone.yml
workspace:
  base: /data/gitbook
  path: ued

pipeline:
  restore-cache:
    image: drillster/drone-volume-cache
    restore: true
    mount:
      - node_modules
    volumes:
      - /data/gitbook/ued/:/cache/

  build:
    image: node:7
    secrets: [ UPYUN_USERNAME, UPYUN_PASSWORD ]
    commands:
      - npm install -g cnpm --registry=https://registry.npm.taobao.org
      - cnpm install
      - npm run build
      - npm run docs

  rebuild-cache:
    image: drillster/drone-volume-cache
    rebuild: true
    mount:
      - docs
      - node_modules
    volumes:
      - /data/gitbook/ued/:/cache/

  restore-cache:
    image: drillster/drone-volume-cache
    restore: true
    mount:
      - docs
    volumes:
      - /data/gitbook/ued/:/cache/

  docs:
    image: plugins/git
    secrets: [ GITHUB_USERNAME, GITHUB_EMAIL, GITHUB_PASSWORD, GITHUB_REPO ]
    commands:
      - git config --global user.name $GITHUB_USERNAME
      - git config --global user.email $GITHUB_EMAIL
      - git clone $GITHUB_REPO $$DEPLOY_DIR
      - cp -rf docs $$DEPLOY_DIR
      - cd $$DEPLOY_DIR
      - git add docs
      - updated_at=$(date "+Docs updated:%Y-%m-%d %H:%M:%S")
      - git commit -m "$updated_at"
      - git push origin master -f
      - cd ..
      - rm -rf $$DEPLOY_DIR
    environment:
      - DEPLOY_DIR=.deploy_git

branches: master
```
上面的`.drone.yml`文件中有几点值得注意
- pipeline中的每一步都是一个独立的docker环境，数据是隔离的。但是volume的数据是可以共享的，`drillster/drone-volume-cache`这个镜像能帮我们做到生成cache和取出cache。
- drone可以在后台配置全局变量，使用的时候在对应pipeline中的secrets里面声明即可。
- 每个pipeline中可以用`environment`独立配置环境变量，但是因为drone有一个预编译过程，使用变量的时候需要`$$DEPLOY_DIR`这么使用。
- `git clone`支持https，可以通过`https://[username]:[password]@github.com/[username]/[project_name].git`的方式直接获取，这些值可以放在全局变量中。之前思维一直被限制在ssh上，总想着如何配置ssh的key，最后发现在当前情景下还是https的方法来的简单。
