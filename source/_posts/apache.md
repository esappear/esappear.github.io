---
title: mac中apache的基本配置
date: 2017-04-05 22:05:24
tags: [mac, apache]
---

#### 主要相关的配置文件

```
sudo vim /etc/apache2/httpd.conf # apache的主要配置文件
sudo vim /etc/apache2/extra/httpd-vhosts.conf # 配置虚拟主机
sudo vim /etc/hosts # host配置文件
```
三个主要的配置文件，`/etc/apache2/httpd.conf`为主要配置文件，模块开启和关闭什么的都在里面，`/etc/apache2/extra/httpd-vhosts.conf` 就是用来配置apache的虚拟主机的，包括80端口的默认http服务和403端口的默认https服务，`/etc/hosts` 目前只知道用`127.0.0.1 shawn.me`来配置虚拟主机。

#### 语法检查与重启
```
sudo apachectl configtest # 检查配置文件
sudo apachectl restart # 重启
```
每次修改配置文件后都要对配置文件进行语法检查，然后重启服务

##### [添加虚拟主机](http://www.cnblogs.com/snandy/archive/2012/11/13/2765381.html)
```
<VirtualHost *:80>
    DocumentRoot "/Library/WebServer/Documents"
    ServerName localhost
    ErrorLog "/private/var/log/apache2/localhost-error_log"
    CustomLog "/private/var/log/apache2/localhost-access_log" common
</VirtualHost>
```

#### [开启ssl](http://www.cnblogs.com/y500/p/3596473.html)
##### 生成主机密码
```
mkdir /private/etc/apache2/ssl
# 在/etc目录下也行，/etc 其实是个symlink, 指向/private/etc
cd /private/etc/apache2/ssl
sudo ssh-keygen -f server.key
```

##### 生成证书请求文件
```
sudo openssl req -new -key server.key -out request.csr # 需要填一连串的验证信息，验证信息不通过将被标记为不安全的私密链接
```

##### 生成ssl证书
```
sudo openssl x509 -req -days 365 -in request.csr -signkey server.key -out server.crt
```

##### apache 配置
- `/private/etc/apache2/httpd.conf`去掉下面代码原来的注释
```
LoadModule ssl_module libexec/apache2/mod_ssl.so
Include /private/etc/apache2/extra/httpd-ssl.conf
Include/private/etc/apache2/extra/httpd-vhosts.conf
```

- `/private/etc/apache2/extra/httpd-ssl.conf`去掉下面代码原来的注释
```
SSLCertificateFile "/private/etc/apache2/ssl/server.crt"
SSLCertificateKeyFile "/private/etc/apache2/ssl/server.key"
```

- `/private/etc/apache2/extra/httpd-vhosts.conf`添加403的虚拟主机
```
<VirtualHost *:443>
    SSLEngine on
    SSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL
    SSLCertificateFile /private/etc/apache2/ssl/server.crt
    SSLCertificateKeyFile /private/etc/apache2/ssl/server.key
    ServerName localhost
    DocumentRoot "/some/website/directory/"
</VirtualHost>
```

##### 可能的问题
- 403 没有权限查看
  ```
  <Directory />
    AllowOverride none
  #    Require all denied
  </Directory>
  ```
  注释掉`/etc/apache2/httpd.conf`文件中`directory`标签内的`Require all denied`，不然访问虚拟主机里配置的DocumentRoot会直接报没有权限。


为什么会写这个？其实我只想配置下HTTPS而已。。。
