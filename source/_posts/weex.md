---
title: Weex初体验
date: 2018-05-27 14:23:54
tags: [Weex, 总结]
---

是时候写点东西了。

话说这段经验已经跟团队内的人分享过两次了，直接把之前整理的大纲挪上来就好，但是跟别人做的总结跟自己做的总结总是有点不一样的，还是重新整理下吧。

# What is Weex
> 一个使用 Web 开发体验来开发高性能原生应用的框架。

这是`Weex`的自我介绍，高不高性能可以再议，但是Web开发体验却是真的。

`Weex`俗称`Vue Native`，类似于`React`的`React Native`，都试图用WEB技术来写NATIVE。与此类似的技术还有`NativeScript`、小程序和快应用等等。现在只比较`Weex`和`RN`，两者最大的区别从他们的宣传理念便可见端倪：前者是`Write once, run everywhere`，后者是`Learn once, write everywhere`。`RN`可以看做是一种语法，既可以用来写Web，又可以写Native，甚至还能写VR（见React 360），但是两者是互相隔离开的，两者用的都是不同的组件库。而`Weex`则可看做是一种兼容Web、Android、iOS三端的解决方案，一份代码可同时在三端运行，极大的提高了代码的复用性。

# How Weex Works
![Weex 工作原理图](https://weex.apache.org/cn/guide/images/flow.png)
> 在移动应用客户端里，Weex SDK 会准备好一个 JavaScript 执行环境，并且在用户打开一个 Weex 页面时在这个执行环境中执行相应的 JS bundle，并将执行过程中产生的各种命令发送到 native 端进行界面渲染、数据存储、网络通信、调用设备功能及用户交互响应等功能。

上面的原理图和描述源于其官网，简单的说，`Weex`就是在Native环境中运行一份JS代码，并通过与Native的交互达到页面渲染、数据存储等功能。换句话说，不管我们在开发环境怎么折腾，只要最后把一份JS代码交给Native就OK。从这个角度来说，`Weex`对开发者还是蛮友好的。

# How to Use
其实很简单。
1. 安装`weex-toolkit`
`npm install -g weex-toolkit`
2. 创建项目
`weex create awesome-project`
3. 安装依赖
`cd awesome-project && npm install`
4. 开发
  - 在浏览器预览
  `npm run dev & npm run serve`
  - 在App内预览（启一个静态server，然后用App扫一扫即可）
  `anywhere # 一个很有用的npm包，可以在任意目录下启动一个静态服务。`
5. 打包
`npm run build`

# Project in Pratice
## Why Weex
- 每一个前端工程师都有一个全栈的梦想
- 用Web写Native，方便人力资源的流动和调用
- 编写适用三端的组件，提高代码的可复用性

## Main Packages
- weex
- vue + vue-router + vuex # 三套马车，终于齐全了
- weex-ui
- weex-axios # 可在weex使用的类axios库
- weex-bindingx # 用表达式来调用原生动画的库

## Main Output
在项目实践的时候，除了正常的业务逻辑的编写，一个主要产出就是各种拓展的模块和组件了，这也正体现了weex代码高复用性的特点。

### Diff in Module and Component
在跟客户端同学交流的过程中，发现他们最容易搞混的概念就是模块和组件了，觉得有必要区分下：
- 模块：功能层面的封装、在JS中使用、编程式调用
- 组件：UI层面的封装、在模板中使用、声明式调用

### Customer Modules
- qcModal # 自定义样式的modal
- qcShare # 用于分享
- qcNavigator # 用于跳转原生页面
- qcTrack # 用于埋点
- qcTel # 用于拨打电话

### Customer Compents
- qc-rich-text # 富文本
- qc-qr-code # 二维码

Tips: 由于weex追求的是三端均可正常使用，因此对于上面的自定义模块和组件，Web, Android和iOS都需要有各自的实现，同时保持接口一致。

## Main Problems
在开发过程中，不踩坑是不可能的，其中最大的包括以下几个。
### Pack
由于历史原因，核心项目没有前后端分离，所以最后不论怎么着，我都要把`weex`项目引用到核心项目中去。同时我需要处理怎么把打包好的JS文件给到客户端，并实现热更新（这点也是促使我们使用`weex`的很重要的一点）。

最后的实现方式是，修改了`weex`项目的打包配置，在生成js文件之后，一方面将其中给Native使用的js文件生成一份基于MD5的版本号映射文件`version.json`或`version_test.json`，并将该文件和之前打包好的文件上传到upyun，然后App可以在每次启动时获取这个版本文件，并更新其静态资源，从而实现热更新。另一方面，我们会将整个项目打包上传自己的npm服务器上，并在核心项目中安装引用这个npm包。这样，客户端和Web端都能同时使用整个`weex`项目的业务代码，达到一份代码三端使用的目的。

### Navigator
其实`weex`提供了一个`navigator`的模块，用于实现页面间的跳转。但由于实际项目中多个页面共享了`vuex`中的状态（如购物车的状态需要多个页面共享），而`vuex`状态的持久化比较麻烦，同时web端页面的跳转只能用`vue-router`来实现，因此最后舍弃了`navigator`，直接用`vue-router`的`abstract`模式去管理页面的跳转。

### Animation
`weex`提供的`animation`只有一个`animation.transition(el, options, callback)`的API，当我需要实现复杂动画的时候，如实现一个抛物线动画的时候，我只能多次调用这个API，并在每次的callback中指定下一次调用。但这样的调用涉及到多次上下文的切换，造成的后果就是在安卓上会卡顿。在尝试过自定义的`animation`模块之后，我们发现了`weex-bindingX`这个好东西，可以直接用动画表达式的方式一次性将需要执行的动画通知到客户端，从而减少了上下文切换的成本。
```
BindingX.bind({
  eventType: 'timing',
  props: [{
    element: el,
    property:'transform.translateX',
    expression: `linear(t, ${from.left - to.left}, ${to.left - from.left}, ${duration})`,
  }, {
    element: el,
    property:'transform.translateY',
    expression: `easeInSine(t, ${from.top - to.top}, ${to.top - from.top}, ${duration})`,
  }]
});
```

### Style Compatibility
样式兼容其实才是整个开发过程中最让人蛋疼、懵逼的问题，一份代码需要匹配三端，意味着我需要确保这一份CSS在三端的显示是正常的。然而这实际开发过程中经常有跟预期不一样的表现，其中的主要原因包括以下两点：
- 安卓上的盒子模型是`overflow: hidden`的，所有超出盒子的内容就直接不展示。这个特点让人很难受，特别是在写组件的时候，经常会有浮层等一些超过父级元素大小的子元素，这个在`web`上可以正常显示的，但在安卓上就不行了。
- 没有了文档流的概念。在web中，默认情况下所有的的元素都是会按照顺序自动计算宽高从上往下排列的，超过窗口的会自动滚动，超过盒子的也会显示，但在Native中，这些滚动必须要用scroll来实现。而且一旦一个盒子没有声明宽度或高度，它的渲染结果就会很有可能表现的很匪夷所思，如我曾遇到过的iOS上的黑线问题。因此，**建议盒子最好都要显式的声明宽度和高度，不要依赖自动计算。**

### Degradation Programs
由于`weex`是一门新技术，为了保留后路，我们也做好了在App内直接使用web页面的准备，`version.json`中的`weex-enabled`就是控制是用weex页面还是用web页面的开关。但由于项目中有些页面需要跳转到APP原来的Native页面，因此同样的页面跳转逻辑，我们需要保证web到Native和weex到Native都是OK，故而调试成本又上去了。

### Render
由于Native的限制，`weex`中的`vue`只能使用`v-if`，不能使用`v-show`，也就是说每当`v-if`对应的布尔值发生变化，其控制的元素就要重新渲染。当然这对一般的元素可能还不觉得有什么，但是要是有`v-if`要是控制了长列表的渲染，那状态切换时页面可就是卡的不要不要的了。当然后来`weex`提供了`recycle-list`的组件，不过这都是后话了。

# After
说心里话，这个项目之后，我的心里还是蛮受伤的。想起今年年初的[年初计划](/2018/01/07/2017/)，当时还是兴致勃勃的要尝试`Weex`，但尝试过后，我的第一感觉居然是不想再用了，其主要原因在于兼容多端的困难，尤其是Web和Native的样式表现差的太远，经常在Web上好好的样式到安卓上就挂了，好不容易安卓好了，iOS上又有问题。再加上没有一个好用的调试工具，因而在调试样式的时候还是蛮痛苦的。

不过话说回来，我们为什么一定要执着于用`web`来写`Native`应用，`web`应用和`Native`应用到底有什么区别。

经调研，不外乎渲染能力、离线能力、复杂动画、硬件接口这几点。但其实随着硬件的升级，渲染能力的差距其实已经很小了；而且对于简单的页面来说，两者几乎的差别真的是微乎其微。要知道，在定位问题的时候其他人问的关于APP的最多一个问题就是“这个页面是APP还是web”了。当前发展火热的`pwa`技术也填补了web离线能力的欠缺。不过对于复杂动画和调用硬件接口这两点，`web`应用还真是比不过`Native`应用了。

所以说，在决定到底是web还是Native的时候，还是得多考虑下具体的业务需求。

PS: 虽然在`weex`上受了点伤，但是最近还是被小程序（当然不是那种嵌着webview的假小程序）吸引了。看着自己写的demo在微信中流畅的切换，感觉还是挺好的。嘻嘻~
