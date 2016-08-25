---
title: Promise对象
date: 2016-08-23 23:35:03
tags: [Promise, ES6]
---
最近调研Promise,在小组内部分享,懒得再展开整理了,先把提纲什么的放在这么晾晾~
### promise的由来 
解决异步编程的各种困难: 1.异常处理; 2.函数嵌套过深,回调地狱; 3.异步转同步

其主要两种解决方式: 1.事件发布与订阅模式; 2.Promise/Deferred 模式

### CommonJs的promise模型
#### Promise/A
Promise对象有三种状态: 未完成(pending)、完成(fulfilled) 和 失败(rejected).
Promise对象的状态转化只有两种:
    > pending => fulfilled;
    > pending => rejected;
Promise对象的状态一旦发生改变,将不能再更改.

Promise对象的then方法，可接受三个回调函数 onFulFilled, onRejected, onProgress(返回进度消息时)

#### Promise与Deferred的区别
Deferred主要用于内部,负责维护模型的状态,Promise则用于外部,暴露接口给外部添加业务逻辑.

#### 链式调用
then()方法调用后返回的是一个新的Promise对象,该对象同样也有then()方法,因此可实现链式调用(promise chain).
基本原则: 一个promise对象必须是fulfilled状态或rejected状态才能调用then方法中的callback.
1.内部链式调用
```
return getUsername()
.then(function (username) {
    return getUser(username)
    .then(function (user) {
        // if we get here without an error,
        // the value returned here
        // or the exception thrown here
        // resolves the promise returned
        // by the first line
    })
});
```
2.外部链式调用
```
return getUsername()
.then(function (username) {
    return getUser(username);
})
.then(function (user) {
    // if we get here without an error,
    // the value returned here
    // or the exception thrown here
    // resolves the promise returned
    // by the first line
});
```
第一种方式看起来跟普通的回调函数没什么区别,也很容易掉到回调地狱中, 第二种逻辑清晰, 但是具体业务中可根据业务逻辑内外部混合链式调用.
```
return getUsername()
.then(function (username) {
    return getUser(username);
})
// chained because we will not need the user name in the next event
.then(function (user) {
    return getPassword()
    // nested because we need both user and password next
    .then(function (password) {
        if (user.passwordHash !== hash(password)) {
            throw new Error("Can't authenticate");
        }
    });
});
```


#### Promise/B 
增加了API，如when方法

#### Promise/D
如何判断一个对象是Promise对象

### Promise/A+组织
对then方法进行了补充
将then方法作为promise对象的甄别方法

### Promise实现
1.Q模块 主要基于Promise/A
2.ES6 Promise 基于Promise/A+

主要差别：
1.notify callback
2.可通过操作Deferred对象更改Promise对象的状态
3.值的传递：
    > 前者必须返回 promise对象才能将promise对象resolve的值传递给那个then方法里的回调函数
    > 后者then方法中返回的值（非promise对象）可直接传递给下个then方法

#### Angular中的Promise - $q，依赖于$rootScope
两种主要返回promise方式：类Q和类ES6
##### 1.类Q
创建Deferred对象: `var deferred = $q.defer()`
Deferred对象的API
`deferred.resolve(value)`
`deferred.reject(reason)`
`deferred.notify(value)`
 
返回Promise对象: `return deferred.promise`
 
Promise 的方法
`promise.then(successCallback, errorCallback, notifyCallback)`
`promise.catch(errorCallback)`
`promise.finally(callback, notifyCallback)`
 
##### 2.类ES6
```
 $q(function(resolve, reject){
    //Do somthing to resolve
    setTimeout(function(){
        if (Math.random() > 0.5) {
            resolve('resolved');
        } else {
            reject('rejected');
        }
    }, 1000)
 })
```

`$q.resolve(value)`
直接返回一个fulfilled状态的promise对象, 并向之后then方法中的回调函数传入值value
`$q.reject(reason)`
直接返回一个rejected状态的promise对象, 并向之后then方法中的回调函数传入值reason

`$q.all(promises)`
`$q.race(promises)`

#### ES6 Promise
创建promise对象
```
var promise= new Promise(function(resolve, reject){
    //Do somthing to resolve
    setTimeout(function(){
        if (Math.random() > 0.5) {
            resolve('resolved');
        } else {
            reject('rejected');
        }
    }, 1000)
});
```

1.异步调用
2.[[PromiseStatus]], [[PromiseValue]]，每次调用then方法后都返回一个新的promise对象
3.promise对象的API
`then(onFulfilled, onRejected)`, `catch(onRejected)`
4.Promise的API
`all(promises)`, `race(promises)`
`resolve(value)`, `reject(reason)`




