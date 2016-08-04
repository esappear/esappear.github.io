---
title: 圣杯布局和双飞翼布局
tags:
  - css
  - layout
  - 笔记
date: 2016-08-04 09:48:43
---

再整理下传说中的圣杯布局和双飞翼布局~
两种方式主要想实现的布局如图所示:
![布局](http://zoneke-img.b0.upaiyun.com/418f7f9fbc1335a2753ff03c1113d203.png)
而且其关键要求是:** `#main`必须是优先于`#left`和`#right`加载的.**
#### 圣杯布局
据说圣杯布局源自[In Search of the Holy Grail](http://alistapart.com/article/holygrail), [这里也有中文翻译版](https://segmentfault.com/a/1190000004524159).
##### 主要思想
> 给包裹着三个元素的 container 加一个 padding, 让 padding-left 和 padding-right 的数值是 left 和 right 的宽度，然后利用相对定位把他们再移动在两旁。

圣杯布局的HTML结构如下:
``` bash
<div id="header">header</div>
<div id="container">
    <div id="main" class="column">main</div>
    <div id="left" class="column">left</div>
    <div id="right" class="column">right</div>
</div>
<div id="footer">footer</div>
```

CSS 样式如下:
``` bash
body {
    min-width: 550px;      /* 2x LC width + RC width */
}
#container {
    padding-left: 200px;   /* LC width */
    padding-right: 150px;  /* RC width */
}
#container .column {
    position: relative;
    float: left;
}
#main {
    width: 100%;
}
#left {
    width: 200px;          /* LC width */
    right: 200px;          /* LC width */
    margin-left: -100%;
}
#right {
    width: 150px;          /* RC width */
    margin-right: -150px;  /* RC width */
    /* 另一种写法 */
    ** /* margin-left: -150px; right: -150px; */ **
}
#footer {
    clear: both;
}
/*** IE6 Fix ***/
* html #left {
    left: 150px;           /* RC width */
}
```
##### 主要步骤
2. 需要三栏布局的#container容器利用`padding-left: 200px`和`padding-right: 150px`为左右栏腾出空间.
3. 对`#main`、`#left`和`#right`指定宽度,尤其是`#main`指定了宽度`100%`,根据父级块级元素和子级块级元素之间的宽度关系**(子级块级元素将占据父级块级元素除`margin`、`padding`和`border`之外的所有宽度)**,子元素将占据剩下的所有空间.
4. 利用`margin`负值将`#left`设置`margin-left: -100%`,这时`#left`将被顶到`#main`之前左侧的位置,由于之前设置了`position: relative`,因此可通过`right: 200px`让`#right`向左偏移其宽度的距离,从而到达之前`#contain`腾出的左侧的位置.
5. 通过`margin-left: -150px`将`#right`往左拉回其宽度的距离,从而使其到达`#contain`的右侧位置.

关键点在于: 
- `margin`负值: `margin-left: -100%`和`margin-left: -150px`
- 相对定位后的位置调整: `position: relative; right: 200px`

##### 如果要等高
需要对`margin-bottom`和`padding-bottom`进行调整
``` bash
#container {
  overflow: hidden;
}
#container .column {
  padding-bottom: 20010px;  /* X + padding-bottom */
  margin-bottom: -20000px;  /* X */
}
```
*****
#### 双飞翼布局
##### 主要思想
> 在 container 里面再添加一个 div, 然后对这个 div 进行 margin-left 和 margin-right.

HTML 较圣杯布局的调整主要是在`#main`中添加了`#wrap`, 并将主要内容写在`#wrap`中.
``` bash
<div id="header">head</div>
    <div id="container cleanfix">
        <div id="main">
            <div id="wrap">main</div>
        </div>
        <div id="left">left</div>
        <div id="right">right</div>
    </div>
<div id="foot">foot</div>
```
其CSS 样式如下:
``` bash
#left, #right, #main {
    float: left;
}
#left {
    width: 40px;
    height: 60px;
    margin-left: -100%;
}
#right {
    width: 60px;
    height: 80px;
    margin-left: -60px;
}
#main {
    width: 100%;
}

#wrap {
    margin-left: 40px;
    margin-right: 60px;
}
```

#### 圣杯布局和双飞翼布局的异同点
1.`#container`内部的三个元素全部左浮动，然后清除浮动防止影响
2.给`#main` 100% 的宽度让他占满一行
3.给 `#left` -100% 的`margin-left` 让他移动到最左边，给 `right` 和他宽度一样的负 `margin` 让他移动到最右边
4.针对移动后 `#main` 的两边会被 `#left` 和 `#right` 重合覆盖掉做出不同的改变，这儿也就是两个布局的本质区别
   > 圣杯布局会给 `#container` 内边距，左右分别为 `#left` 和 `#right`的宽度，然后再利用相对定位移动 `left` 和 `right`
   > 双飞翼布局会在 `#container` 里面再加一层 `wrap` ，然后把内容都写在 `wrap` 里面，正对 `wrap` 设置他的 `margin`, 左右外边距和 `left` 与 `right` 一样



#### 主要来源
[In Search of the Holy Grail](http://alistapart.com/article/holygrail)
[关于圣杯布局](https://segmentfault.com/a/1190000004524159)
[那些年，奇妙的圣杯与双飞翼，还有负边距](https://segmentfault.com/a/1190000004579886#articleHeader1)

我是大自然的搬运工~