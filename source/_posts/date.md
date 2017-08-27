---
title: 一个时区的坑
date: 2017-08-27 00:10:38
tags: [坑, tips]
---
目测自己应该很久才会有一次比较大的产出了，但是如果每次都等着憋大招，那什么也不用做了。那还是从平时踩到的坑开始吧，即便只是解决一个比较小的问题，还是做下笔记比较好，谨防以后再次碰到。

后端传的时间均为`2017-08-25T10:00:00`的格式，这个在比较两个均没有offset的时间的时候没什么问题，但是一旦将这个时间与当前时间比较就会有问题，因为`new Date()`出来的`Date`对象是带着offset信息的， 如`Fri Aug 25 2017 14:43:03 GMT+0800 (CST)`。因此，在与当前时间比较时，一定要手动加上offset。
```
var time = '2017-08-25T10:00:00';
new Date(time) // Safari Fri Aug 25 2017 18:00:00 GMT+0800 (CST)
new Date(time) // Chrome Fri Aug 25 2017 10:00:00 GMT+0800 (CST)
```
angular 中添加一个filter，方便复用。
```
app.filter('addTimeZoneOffset', [function () {
  var _offset = parseInt(new Date().getTimezoneOffset() / 60);
  // 获取当前时区的offset，东八区值为-8，表示格林时间落后东八区8个小时。
  _offset = (_offset < 0 ? '+' : '-') + (Math.abs(_offset) < 10 ? '0' : '') + Math.abs(_offset) + ':00';
  // 东八区为+08:00
  return function (time) {
    if(!time || time.length !== 19) return time;
    // '2017-08-20T18:00:00' 长度为19的时候才加offset
    return time + _offset;
  }
}])
```

Tips: 下次再遇到不同浏览器表现不一致、跟时间判断相关的问题，可以考虑下是不是时区offset的问题。
