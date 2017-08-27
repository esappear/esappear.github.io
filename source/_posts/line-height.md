---
title: line-height
date: 2017-03-26 23:12:17
tags:
---

# Box

- 普通流（文档流）：只要不是float和绝对定位方式布局的，都在普通流里面。
- 浮动：浮动的框可以向左或向右移动，直到它的外边缘碰到包含框或另一个浮动框的边框为止。
- 定位：相对定位在文档流之中，绝对定位则脱离文档流。


## Block Box
宽度的计算
块级元素框的水平部分 = 其父元素的width = margin-left+margin-right + padding-left + padding-right + border-left + border-right + 自身width

### BFC(Block Formatting Context)
#### 特点：
1. 内部盒子会在垂直方向排列
2. 同一个BFC中的元素可能会发生margin叠加；
3. BFC就是页面上的一个隔离的独立容器，里外互相不影响
4. 计算BFC的高度时，考虑BFC所包含的所有子元素，连浮动元素也参与计算；
5. 当元素不是BFC的子元素的时候，浮动元素高度不参与BFC计算（既是常见的盒子塌陷问题）

#### 触发条件：
1. 根元素 <html>
2. float属性不为none
3. position为absolute或fixed
4. display为inline-block, table-cell, table-caption, flex, inline-flex
5. overflow不为visible

#### 其作用
1. 清除浮动
2. 阻止边距折叠
3. 用于布局，什么两栏自适应高度之类的

## Line Box
- 匿名文本：未包含在行内元素的字符串
- 行内框：非替换元素，行内框高度=line-height；替换元素，行内框高度=内容区宽度（行间距不应用到替换元素）
- baseline: 字母x的下边缘线（居然还有个单位叫x-height，即字母x的高度，vertical-align: middle并不是真正的垂直居中对齐，而是与基线往上1/2 x-height的距离）
- line-height: 两条baseline之间的距离

> 可替换元素：展现不是由CSS来控制的、外观渲染独立于CSS的外部对象，如img、input、textarea、select等
> 非替换元素：与可替换元素相反，大部分元素皆属于该类
