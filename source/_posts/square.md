---
title: 自适应的正方形
date: 2016-08-04 20:15:12
tags: [布局, layout, padding, 百分比]
---
想要让元素的宽度随着屏幕宽度自适应,一般使用百分比就好了,但是想要让元素的高度随着屏幕自适应,那就有难度了.今天终于得知了这个奇淫技巧.
![需要实现的布局](http://zoneke-img.b0.upaiyun.com/3e42e69ebfdc977ea41c7506da838a74.jpg)
##### 主要要求
> 图片为正方形
> 图片大小能随着屏幕宽度自适应

##### 最终实现的HTML代码
``` bash
<ul class="list">
    <li class="item">
        <div class="imgWrap">
            <img src="..." alt="" />
        </div>
    </li>
    <!-- li * N -->
</ul>
```

##### CSS
``` bash
.list {
  padding: 0 15px;
  font-size: 0; /* inline-block布局需要font-size:0 防止子元素宽度溢出 */
  margin: 0 -5px; /* .imgWrap设了margin: 0 5px, 防止.list在水平位置上偏移 */
}
.item {
    display: inline-block;
    width: 33.33333%; /* 百分比,每行3张图片 */
    margin: 10px 0;
    .imgWrap {
      margin: 0 5px;
      height: 0;
      padding-bottom: 100%; /* 关键: 将图片的外围元素高度设为0, 并将其padding-bottom 设为100% */
      overflow: hidden; /* 隐藏正方形之外的区域 */
    }
  }
``` 

##### 关键点: 元素上padding的百分比值是相对于父元素的宽度的.
    height: 0;padding-bottom: 100%;
 要想实现正伸缩的正方形区域,其关键在与将元素的高度设为0, 并将其`padding-bottom`或`padding-top`值设为100%. 其原因是**元素上padding的百分比值是相对于父元素的宽度的**, `padding-bottom: 100%`可强制使得计算后的`padding-bottom`值等于其宽度值. 由于`padding`是内边距, 是在盒子内部的, 盒子内部的元素是能在该区域出现的, 所以图片是可以显示的. 再加上`overflow: hidden`, 整个元素就是一个可随屏幕宽度变化的正方形了. 
 
 另外, 如果想要在该正方形区域中怎么展示该图片, 那就是另外的问题了.
 

