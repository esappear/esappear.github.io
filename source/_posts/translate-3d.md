---
title: Android机型 translate-3d的点击穿透问题
date: 2016-09-26 16:23:07
tags: [CSS, translate-3d, 点击穿透]
---

某元素
```
tranform: translate3d(0px, 0px, 36px);
```
点击浮层会有点击穿透问题

解决方法：

- 父元素：
	
```
transform-style: preserve-3d; //使被转换的子元素保留其 3D 转换：
-webkit-transform-style: preserve-3d;
```
	
- 子元素：

```
transform: translateZ(100px);
-webkit-transform: translateZ(100px);
```

只要子元素的`translateZ`值大于某元素`translate3d`中z轴的值，则点击子元素，不会发生点击穿透；
