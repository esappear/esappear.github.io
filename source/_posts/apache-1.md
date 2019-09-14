---
title: apache中的代理
date: 2018-12-02 23:47:59
tags: [apache, 代理]
---

1. `sudo vim /etc/apache2/httpd.conf`
将 `Include /private/etc/apache2/extra/httpd-vhosts.conf` 这行的注释 # 去掉。

2. `sudo vim /etc/apache2/extra/httpd-vhosts.conf`
添加以下内容并保存（具体域名信息和代理端口可自由配置）：
```conf
<VirtualHost *:80>
    ServerName "local.waptest.taobao.com"
    ServerAlias "local.wapa.taobao.com"
    <Proxy *>
        Order Deny,Allow
        Deny from all
        Allow from 127.0.0.1
    </Proxy>
    ProxyRequests Off
    ProxyPass / http://127.0.0.1:3333/
    ProxyPassReverse / http://127.0.0.1:3333/
</VirtualHost>
```
3. 重启 Apache：`sudo apachectl restart`

4. 添加绑定（具体域名信息和上面的一致）：
`sudo vim /etc/hosts`
`127.0.0.1 local.waptest.taobao.com local.wapa.taobao.com`
