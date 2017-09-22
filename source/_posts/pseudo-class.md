---
title: 总结下那些常用的伪类和伪元素
date: 2017-03-28 23:12:44
tags: [CSS, 伪类, 伪元素]
---
伪类和伪元素应该是CSS中常见的两个概念了，两者区别在于前者等效于一个类，后者等效于一个元素，伪类的效果可以通过添加一个类来实现，伪元素的效果则需要通过添加一个元素才能实现。伪类使用时用`:`，伪元素使用时用`::`。本来这两个概念在日常工作中都是很平安的，直到发现自己写过的`input[type="checkbox"][checked="checked"]`对checked的input元素失效，才发现自己需要的是`input[type="checkbox"]:checked`。虽然前者作为属性选择器，对于在属性中声明checked状态的input是管用的，但对于不显式声明checked状态的input就无能为力了，只能靠后者了。由此，决心重新整理下那些常用和 **将来可能会常用** 的伪类和伪元素，顺便归类和标记一下~

### 伪类
#### 状态相关
几乎所有元素通用，不过常用于a元素，:focus还比较常用于表单元素，:hover也很常用
- `:link`
- `:visited`
- `:hover`
- `:active`
- `:focus`

#### 结构相关
##### 父子元素间的元素位置
- `:first-child`
- `:last-child`
- `:nth-child` 根据元素的位置匹配一个或者多个元素，它接受一个an+b形式的参数 如:nth-child(2n)
- `:nth-last-child` 与:nth-child类似，但是从最后一个子元素开始计数
- `:only-child`

##### 父子元素间的元素类型
- `:first-of-type` 匹配当前元素是其父元素的第一个该类型元素的元素
- `:last-of-type`
- `:nth-of-type`
- `:nth-last-of-type`
- `:only-of-type`

##### 其他
- `:not` 匹配不符合参数选择器的元素
- `:target` 匹配URL中的锚指向的元素
- `:empty` 匹配没有子元素的元素

#### 表单相关
顺便翻了下表单元素，其包括 form input select option button textarea label fieldset legend optgroup
然而，我居然没怎么用过后面三种。。

##### 表单通用
- `:disabled` 禁用的
- `:enabled` 可用的
- `:required` 必选的
- `:optional` 可选的
- `:read-only` 只能读
- `:read-write` 能读能写
- `:default` 默认样式，对button input option 有用，目测平时用不着
- `:valid` 合法的
- `:invalid` 非法的
- `:focus` // 通用伪类，对于表单元素来说更常见

对于上面成双成对的，日常使用的话应该只会用其中一个，如`:disabled`,`:required`,`:read-only`,毕竟他们的另一半都是默认的。。

##### 文本类
- `:placeholder-shown` // 草稿中 可以指定显示placeholder的时候input元素的样式，注意这不能修改placeholder的样式，如果想要修改，请使用`::placeholder`

##### 选择类
- `:checked` 包括`input[type="checkbox"]:checked`, `input[type="radio"]:checked`, `option:checked`(实际上并没有什么卵用，因为option的样式并不能通过CSS来修改)
- `:indeterminate` 未定

##### 数字类
- `:in-range` `:input[type="number"]:in-range` 在指定区间内
- `:out-of-range` `:input[type="number"]:out-of-range` 不在指定区间

### 伪元素
#### 单双冒号皆可
- `::after`
- `::before`
- `::first-letter`
- `::first-line`

即便如此，还是都用`::`吧，与伪类区分开来。

#### 仅双冒号
- `::selection` 文档中被用户高亮的部分，只支持color, background-color, cursor, outline, text-decoration, text-emphasis-color和text-shadow
- `::placeholder` input元素中placeholder文本的样式
