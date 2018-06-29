---
title: Ubuntu 16.04下折腾记
date: 2018-06-29 15:20:57
tags: [ubuntu, shell, linux, docker, daocloud, 笔记]
---
# 安装zsh和oh-my-zsh
见[Ubuntu 16.04下安装zsh和oh-my-zsh](/2018/06/29/zsh/)

# 安装nginx
```
sudo apt-get install nginx
```

# 安装docker
## SET UP THE REPOSITORY
```
sudo apt-get update # Update the apt package index

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common # Install packages to allow apt to use a repository over HTTPS

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - # Add Docker’s official GPG key

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

## INSTALL DOCKER CE
```
sudo apt-get update # Update the apt package index.
sudo apt-get install docker-ce # Install the latest version of Docker CE
```

# 使用daocloud
- 创建项目 => 构建镜像(可以通过git hook 自动构建)
- 创建应用 => 部署镜像(可以自动构建镜像完成之后自动发布更新应用)


