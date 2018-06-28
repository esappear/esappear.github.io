---
title: 元素hover时渐隐渐现弹窗（纯CSS）
date: 2016-12-11 15:46:43
tags: [css, hover]
---
若直接用`display:none`和`display:block`则没有渐隐渐进效果，而如果直接用`opacity:0`和`opacity:1`则占据多余的空间，鼠标没有放在图标上也会出现layer。而用`visibility:hidden`和`visibility:visible`则可避免这个问题。

```
.icn {
  margin: 0 30px;
  cursor: pointer;
  position: relative;
  .m-layer {
    opacity: 0;
    visibility: hidden;
    transition: all .3s ease;
  }
  &:hover {
    .m-layer {
      visibility: visible;
      opacity: 1;
    }
  }
}
```
