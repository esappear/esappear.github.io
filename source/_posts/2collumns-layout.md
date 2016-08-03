---
title: 两列自适应布局和三列自适应布局  
date: 2016-08-04 00:09:37
tags: [layout, css, 笔记, 布局, 两列自适应布局]
---
整理下之前的两列自适应布局和三列自适应布局的实现方式
#### 两列自适应布局
##### 绝对定位法
HTML:
``` bash
<div class="left"></div>
<div class="main"></div>
```
CSS:
``` bash
.main {
    margin-left: 200px;
    height: 300px;
}
.left {
    position: absolute;
    left: 0;
    top: 0;
    width: 200px;
    height: 300px;
}
```
*****
##### 左侧浮动法
HTML:
``` bash
<div class="left"></div>
<div class="main"></div>
```
CSS:
``` bash
.main {
    margin-left: 200px;
    height: 300px;
}
.left {
    float: left;
    width: 200px;
    height: 300px;
}
```
*****
##### 主体嵌套法(*主体优先*)
HTML:
``` bash
<div class="main">
    <div class="content"></div>
</div>
<div class="left"></div>
```
CSS:
``` bash
.main {
    float: left;
    width: 100%;
}
.content {
    margin-left: 200px;
    height: 300px;
}
.left {
    float: left;
    margin-left: -100%;
    width: 200px;
    height: 300px;
}
```
个人更偏爱左侧浮动法,简单实用.主体优先的前提下选择主体嵌套法.

#### 三列自适应布局(左右两列定宽,主体自适应)
##### 绝对定位法
HTML:
``` bash
div class="left"></div>
<div class="main"></div>
<div class="right"></div>
```
CSS:
``` bash
.left {
    position: absolute;
    left: 0;
    top: 0;
    width: 200px;
    height: 300px;
}
.right {
    position: absolute;
    right: 0;
    top: 0;
    width: 200px;
    height: 300px;
}
.main {
    margin-left: 200px;
    margin-right: 200px;
    height: 300px;
}
```
****
##### 自身浮动法
HTML:
``` bash
<div class="left"></div>
<div class="right"></div>
<div class="main"></div>
```
CSS:
``` bash
.left {
    float: left;
    width: 200px;
    height: 300px;
}
.right {
    float: right;
    width: 200px;
    height: 300px;
}
.main {
    margin-left: 200px;
    margin-right: 200px;
    height: 300px;
}
```
****
##### 主体嵌套法(*主体优先, margin负值*)
即双飞翼布局的核心部分
HTML:
``` bash
<div class="main">
	<div class="content"></div>
</div>
<div class="left"></div>
<div class="right"></div>
```
CSS:
``` bash
.main {
    float: left;
    width: 100%;
}
.content {
    margin-left: 200px;
    margin-right: 200px;
    height: 300px;
}
.left {
    float: left;
    margin-left: -100%;
    width: 200px;
    height: 300px;
}
.right {
    float: left;
    width: 200px;
    margin-left: -200px;
    height: 300px;
}
```
