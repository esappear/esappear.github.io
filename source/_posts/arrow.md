---
title: 有阴影的三角形
date: 2017-09-03 22:20:34
tags: [css, trick, 三角形]
---
普通的三角形在CSS中可通过指定上下左右四个方向的border来实现。
如下面的代码可以声明出一个宽12px、高6px的倒立的等腰三角形。
```
border-top: solid 6px #fff;
border-left: solid 6px transparent;
border-right: solid 6px transparent;
```
但想要这个三角形有阴影，直接声明`box-shadow`是没用的，因为这个声明是对整个盒子模型生效的，这样声明出来的三角形会在四周有一个“很方”的阴影。

这个问题可以通过再声明一个伪元素，让这个伪元素高度或宽度足够小，所有的阴影效果声明在这个伪元素上。然后让三角形覆盖在上面，这样就可以trick出一个有阴影的三角形了。
```
// less中声明一个带三角和阴影的消息对话框
.message-box {
  width: 300px;
  height: 200px;
  box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.2);
  box-sizing: border-box;
  &.top {
    &::after {
      content: '';
      position: absolute;
      bottom: -6px;
      left: 50%;
      margin-left: -10px;
      border-top: solid 6px #fff;
      border-left: solid 6px transparent;
      border-right: solid 6px transparent;
    }
    &::before {
      content: '';
      width: 12px;
      height: 3px;
      background-color: transparent;
      position: absolute;
      bottom: 0;
      left: 50%;
      margin-left: -10px;
      box-shadow: 0 6px 10px 0 rgba(0, 0, 0, .2);
    }
  }
}
```
![示意图](http://zoneke-img.b0.upaiyun.com/5f360db06ff47bfb370c787a116eaa9b.jpeg)
然而这个方法的问题在于，在那个为三角形贡献阴影的伪元素的`box-shaow`的偏移量和模糊半径如何取值，只能根据视觉效果慢慢调了。只要有点耐心，这个`box-shaow`会跟外面的`box-shaow`和谐相处的。
