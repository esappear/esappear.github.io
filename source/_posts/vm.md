---
title: 图片和文字垂直居中对齐
date: 2016-12-11 15:40:20
tags: [css, 垂直居中]
---
块级元素内的行内元素（包括inline和inline-block）的垂直居中

1. inline-block && 伪元素

	```
	# html
	<div class="parent">
		<img src="" alt="" class="icn" />
		<i class="txt">文字</i>
	</div>
	# css
	.parent { height: 200px;}
	.icn {display: inline-block; vertical-align: middle;}
	.txt {vertical-align: middle;}
	.parent:before {content: ''; display: inline-block; height: 100%; vertical-align: middle;}

	```
	.parent 设置`box-sizing: border-box`可以避免设置border的影响

2. table && table-cell;

	```
	<!-- HTML -->
	<div class="parent">
		<img src="" alt="" class="img" />
		<div class="txt">文字</div>
	</div>
	```
	```
	//display:table方法
	.parent { display: table;}
	.img, .txt {
		display: table-cell;
		vertical-align: middle;
	}
	```
	父元素不要设置height，不然img元素可能会不居中，可通过设置img的padding来调节.父元素的高度。



	**inline-block元素和inline元素的vertical-align方法只能确保元素之间对齐，并不能保证元素在父元素内对齐，常用的设置line-height和height相等的方法并不能真正做到真正的垂直居中。**

	**vertical-align仅对inline元素和inline-block元素（还有table-cell）有效，决定的是该行内元素的基线相对于该元素所在行的基线的垂直对齐。**

	**line-height决定的是当前元素的行高，作用于其行内子元素。**
