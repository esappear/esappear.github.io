---
title: 使用HEXO和Github搭建博客有感
date: 2016-07-31 15:57:26
tags:
- HEXO
- Github
---

总算用HEXO和Github成功的构建了博客。
先是按照[HEXO+Github,搭建属于自己的博客](http://www.jianshu.com/p/465830080ea9)一步一步进行，然而即便在本地已经可以运行，还自己配置简洁美观的主题[NexT.Mist](https://github.com/iissnan/hexo-theme-next)，但是却始终没能成功部署到github上。
``` bash
deploy:
  type: git
  repo:https://github.com/leopardpan/leopardpan.github.io.git
  branch:master
```

这几行配置项看起来是没什么问题的，然而在我尝试了各种可能的type和repo之后，依然想要微笑面对生活。
过程中，我还以为的ssh_key出现了问题，还以为这个仓库还要单独的配上一个Deploy keys。这名字让我差点就信了，直到我在[史上最新版GitHub+Hexo配置系列教程](http://blog.csdn.net/SmallCheric/article/details/51049691)看到这一行。

``` bash
deploy:
  type: git
  repository: https://github.com/suericze/suericze.github.io.git
  branch: master 
```
> 因yml格式问题,所有键值对的”:”冒号后面必须跟有一个空格

于是心中千万头草泥马奔腾而过，在_config.yml的deploy的键值对的":"后加了空格，然后居然成功了。。。

我的天，折腾了半天，最后败在了这几个空格之上。


