---
title: mac中python环境的配置
date: 2016-09-26 16:40:12
tags: [环境配置, mac, python]
---
1. 安装Homebrew 
	`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
	
2. 安装Homebrew Cask
	`brew install caskroom/cask/brew-cask`

3. 用brew安装mysql/python/node/git/iTtem2

4. 安装Oh My Zsh
	`sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
	
5. python 环境安装
	- `brew install python`(mac自带的Python有问题，需要重新安装)
	- `brew install pip`(Python的包管理工具)
	
6. virtualenv 安装
	
	- `[sudo] pip install virtualenv`
	- `cd .virtualenvs && vim postactivate`

	```
	#!/bin/zsh
	# This hook is run after every virtualenv is activated.
	PS1="$_OLD_VIRTUAL_PS1"
	_OLD_RPROMPT="$RPROMPT"
	RPROMPT="%{${fg_bold[white]}%}(env: %{${fg[green]}%}`basename \"$VIRTUAL_ENV\"`%{${fg_bold[white]}%})%{${reset_color}%} $RPROMPT"
	proj_name=$(echo $VIRTUAL_ENV|awk -F'/' '{print $NF}')
	cd ~/projects/$proj_name
	```
	上述最后一行为项目的所在目录
	
7. 克隆git项目
	
	- `cd ~/projects`
	- `git clone [project_address]`
	
8. mkvirtualenv
	- `source /usr/local/bin/virtualenvwrapper.sh`
	- (可将上述命令添加到~/.zshrc中，每次启用zsh都会自动执行该命令)
	- `mkvirtualenv [project_name]`
	- `workon [project_name]`

9. 启动mysql
	- `mysql -u root -p `新建database
	- `mysql -u root -p [database_name] < [mysql file]`
	- 配置项目的env
	
		```
		# -*- coding: utf-8 -*-
		# __author__ = chenchiyuan
		
		from __future__ import division, unicode_literals, print_function
		
		DeployEnv = "gravity"
		
		ConfigOverride = [
		("django", "debug", "True"),
		("django", "template_dubug", "True"),
		("db", "host", "localhost"),
		("db", "username", "root"),
		("db", "password", ""),
		("db", "db_name", "[database_name]"),
		("db", "port", "3306"),
		]
		```

10. 启动服务

	`pip install -r requirements.txt`
	
	`./manage.py runserver [port]`
	
	`./manage.py runserver 0.0.0.0:[port]`可通过局域网ip访问
