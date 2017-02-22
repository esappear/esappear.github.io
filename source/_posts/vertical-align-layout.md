---
title: 左侧定宽、右侧自适应、垂直居中的布局
date: 2017-02-21 23:23:28
tags: [layout, 布局, 垂直居中]
---
具体业务需求：左侧是一个icon，右侧是一大段文字（不定高），要求在各种屏幕宽度下垂直居中

```
<div class="wrap">
	<i class="icn"></i>
	<p class="txt"></p>
</div>
```
```
.wrap {
	font-size: 0; //去掉换行引起的多余空间
}
.icn {
	display: inline-block;
	vertical-align: middle;
	width: 40px;
	height: 40px;
}
.txt {
	display: inline-block;
	vertical-align: middle;
	width: 100%;
	box-sizing: border-box;
	margin-left: -40px; //margin 负值，使得两个inline-block元素在同行显示
	padding-left: 40px; //与左侧的元素拉开距离，可适当增加距离
}
```
关键：margin负值
