---
title: 正则表达式相关的JS方法
date: 2016-09-19 22:50:03
tags: [JavaScript, 正则表达式]
---

## String.prototype
### `String.prototype.split`
语法：`str.split([separator[, limit]])`

参数：`separator`支持正则

### `String.prototype.search`
语法：`str.search(regexp)`

参数：一个正则对象

返回值：所给定字符串的第一个正则匹配项的`index`,没有匹配项则返回-1;直接忽略正则的`g`;

类似于 `String.prototype.indexOf`方法(也支持正则查询)

### `String.prototype.match`
语法：`str.match(regexp)`

参数：一个正则对象，如果传的是其他类型，该类型会用`new RegExp()`转化成正则对象

返回值：有匹配项时返回数组，否则返回`null`；

数组内容：

- 全局匹配时没有捕获项，只有匹配项；
- 非全局匹配数组第一项为匹配项，其他依次为捕获项；
- 如果有嵌套捕获，先捕获外层再捕获内层。

### `String.prototype.replace`
语法：`str.replace(regexp|substr, newSubStr|function)`

参数一：正则或字符串

参数二：

- 新的字符串支持`$`的字符串(`$$、$&、$n`)
- 替换函数（指定参数包括`match, p1, p2, p3, offset, string`）
- `match`为匹配项,`p1,p2,p3`依次为捕获项,`offset`为匹配项在原字符串的`index`,`string`为原字符串；


## RegExp.prototype
### `RegExp.prototype.exec`
语法：`regexObj.exec(str)`

返回值：与`String.prototype.match`的返回值类似，有匹配项时返回数组，否则返回`null`；

数组内容：

- 不管是不是全局匹配，数组第一项为最后一个匹配项，其他依次为该匹配项的捕获项；
- 全局匹配时从`lastIndex`（默认值为0）开始匹配，每次返回的值可能都不一样(循环）；
- 该数组还有两个属性`index`（匹配项在`str`中的`index`）和`input`(原字符串`str`)；
- 调用该方法后的`regexObj`多个属性值有更新：`lastIndex`（上次匹配项最后一个字符的`index`,全局匹配时下次调用将从`lastIndex`开始匹配）、`ignoreCase`（是否忽略大小写）、`global`（是否全局匹配）、`multiline`（是否多行匹配）、`source`（原字符串）；

### `RegExp.prototype.test`
语法：`regexObj.test(str)`

返回值：布尔值，是否有匹配项


