---
title: Ubuntu 16.04下安装zsh和oh-my-zsh
date: 2018-06-29 14:45:32
tags: [linux, shell, zsh, ubuntu, 笔记]
---
[文章来源](https://www.cnblogs.com/EasonJim/p/7863099.html)

最近接连整了几台服务器的环境，觉得有必要记下来。

# 安装zsh
```
sudo apt-get install zsh # 安装
chsh -s /bin/zsh # 更改默认shell
sudo vim /etc/passwd # 把root用户和ubuntu用户的默认shell改成zsh
```

# 安装oh-my-zsh(via git)
```
sudo apt-get install git # 安装git
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" # 安装oh-my-zsh
```

## 安装插件
将对应的插件安装到`$ZSH_CUSTOM/plugins`目录中，并在`~/.zshrc`文件的`plugins`中添加引用，最后`source ~/.zshrc`即可。
### 语法高亮
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```
### 自动补全

```
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions 
```

## 配置主题
与安装插件类似，将主题安装到`$ZSH_CUSTOM/themes`目录中，并在`~/.zshrc`文件的`ZSH_THEME`中修改当前主题，最后`source ~/.zshrc`即可。

# 卸载zsh(暂无必要)
```
sudo sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/uninstall.sh)"
sudo vim /etc/passwd # 把root用户和ubuntu用户的默认shell改回bash
```
