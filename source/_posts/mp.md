---
title: 记一次微信小程序的项目实践
date: 2018-12-02 23:36:34
tags: [小程序, 微信小程序]
---
> 很早之前的项目，一直到现在才总结。。。

### 小程序的几个相关概念
- App
- Page
- Component
- 视图层和逻辑层
  - 视图层->逻辑层 事件
  - 逻辑层->视图层 setData

### 小程序的生命周期
![mina-lifecycle.png](https://developers.weixin.qq.com/miniprogram/dev/image/mina-lifecycle.png?t=18102320)

### 项目结构
#### 构建工具
gulp + typescript
#### 项目结构
```
.
├── 3rd
│   ├── upyun-wxapp-sdk.d.ts
│   ├── upyun-wxapp-sdk.js
│   ├── weapp-qrcode.d.ts
│   └── weapp-qrcode.js
├── app.json
├── app.ts
├── app.wxss
├── assets
│   ├── avatar_female.png
│   ├── avatar_male.png
│   ├── ...
├── behaviors
│   └── district.ts
├── components
│   ├── cell
│   ├── ...
├── filters
│   ├── date.wxs
├── mixins
│   ├── login.ts
├── pages
│   ├── 404
│   ├── login
│   ├── certificate_list
│   ├── discovery
├── project.config.json
├── styles
│   ├── button.wxss
│   ├── checkbox.wxss
│   ├── fonts.wxss
│   ├── input.wxss
│   ├── layout.wxss
│   ├── picker.wxss
│   ├── radio.wxss
│   └── txt.wxss
├── utils
│   ├── cache.ts
│   ├── constants.ts
│   ├── cookie.ts
│   ├── date.ts
│   ├── district.ts
│   ├── meeting.d.ts
│   ├── meeting.ts
│   ├── resource.ts
│   ├── response.d.ts
│   ├── upyun.ts
│   └── utils.ts
├── wx.d.ts
└── wxp.d.ts

68 directories, 54 files
```

### 要点
#### cookie
需要手动保存下来，并在下次请求带上

#### 逻辑复用
- 可以用behavior实现组件间的代码复用，如自定义的表单组件
```
  export default Behavior({
    properties: {
      value: {
        type: Object,
        value: null,
        observer: '_valueChange',
      },
      placeholder: String,
    },
    data: {
    
    },
    methods: {
      _valueChange() {
      
      },
    },
  });
```
- 组件与页面间的代码复用只能用类`extend`或`assign`的方式实现

#### filter要用wxs
```
// date.wxs
module.exports = function dateStr(str, formatter) {
  if (!str) return '';
  var time = getDate(str);
  return formatter.replace('YYYY', time.getFullYear())
    .replace('MM', (time.getMonth() < 9 ? '0' : '') + (time.getMonth() + 1))
    .replace('DD', (time.getDate() < 10 ? '0' : '') + time.getDate())
    .replace('HH', (time.getHours() < 10 ? '0' : '') + time.getHours())
    .replace('mm', (time.getMinutes() < 10 ? '0' : '') + time.getMinutes())
    .replace('ss', (time.getSeconds() < 10 ? '0' : '') + time.getSeconds());
}
```
```
// xxx.wxml
<wxs src="../../filters/date.wxs" module="date"></wxs>

<text>{{date(meeting.open_start, 'YYYY-MM-DD')}}至{{date(meeting.open_end, 'YYYY-MM-DD')}}</text>
```

#### 组件的样式是独立的
可通过`externalClasses`向组件内传递样式类。

#### 组件间值的传递
- 父传子：插值
- 子传父：事件

```
// image_uploader.js
import upyunSvc from '../../utils/upyun';

Component({
  /**
   * 组件的属性列表
   */
  behaviors: ['wx://form-field'],
  properties: {
    tips: {
      type: String,
      value: '请选择图片',
    },
    value: {
      type: String,
    },
    type: String,
  },

  /**
   * 组件的初始数据
   */
  data: {

  },

  /**
   * 组件的方法列表
   */
  methods: {
    chooseImage(event: TapEvent) {
      const that = this;
      wx.chooseImage({
        count: 1, // 默认9
        sizeType: ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
        sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有
        success (res) {
          // 返回选定照片的本地文件路径列表，tempFilePath可以作为img标签的src属性显示图片
          const filePaths: string[] = res.tempFilePaths;
          // /{filemd5}{.suffix}
          wx.showLoading({
            title: '正在上传',
          });
          upyunSvc.upload({
            localPath: filePaths[0],
            remotePath: '/{filemd5}{.suffix}',
            success: function (res: string2AnyMap) {
              wx.hideLoading();
              if (res.statusCode !== 200) {
                wx.showToast({
                  title: res.errMsg,
                });
              } else {
                const data = JSON.parse(res.data);
                const url = `https://zoneke-img.b0.upaiyun.com/${data.url}`;
                that.setData({ value: url });
                that.triggerEvent('change', { value: url }); // triggerEvent
              }
            },
            fail: function ({ errMsg }: { errMsg: string }) {
              wx.hideLoading();
              wx.showToast({
                title: errMsg,
              });
            },
          })
        },
      });
    },
  }
});
```

```
// Demo.wxml
<image-uploader value="http://xxx.avatar.com" name="avatar" bind:change="onImageChange" />

// Demo.js
Page({
  onImageChange(event) {
    console.log(event.detail.value);
  },
})
```

#### 事件的绑定及其值的传递
```
// example.wxml
<view bindtap="jump" data-url="/page/example"></view>
```
```
// example.js
Page({
  jump(event: TapEvent) {
    wx.navigateTo({
      url: event.currentTarget.dataset.url,
    });
  },
});
```


#### Resource + formatter
面向RESTFul规范的接口
