---
title: 重构AngularJS项目有感一
date: 2017-12-10 23:03:31
tags: [AngularJS, 总结]
---
最近在重构一个`AngularJS`的项目，这应该是公司年纪最长的项目了，用的是当时最前卫的MVC框架`AngularJS`。是的，是`AngularJS`, 1.3.16的版本，不是后来重头来过的Angular。这种上了年纪的项目想要重构，除非推到重来，否则都是一件令人头疼的事，我们能做的无非是把这些年积累下来的技术债转化成某些最佳实践，使得代码的可读性、复用性和可拓展性稍微提升一点罢了。
## 资源获取的几个问题
1. 接口对`RESTFul`风格的支持并不友好。项目用了`angular-resource`, 使得前端的请求能够以`RESTFul`的形式去跟后端交互，然而因为某些残忍的现实原因，我们的接口并没有保持良好的`RESTFul`风格，这一点也只能之后跟后端同志沟通时尽量达成一致了。
2. 后端返回的数据结构是经过封装的，（在前后端约定中，所有的请求后端都会返回200的响应，而真正的请求状态和数据藏在响应的body中。）每次请求我们都需要响应主题进行简单判断后才能得到想要的数据。本来这些可以放在`$httpProvider.interceptors`中对所有的请求进行统一处理，但处理后请求下一层的数据都会改变，之前所有的判断都要修改，不得不暂且放弃。
3. 请求之前和请求回来之后需要对数据进行特殊处理（formatter）。这包括get、put请求回来之后的formatter，和post请求之前的formatter。因为一些历史原因，当前项目的formatter很多都是在`controller`中进行的。而比较后期的实践已经把这个放在`factory`中了。
4. 获取同样资源的多次请求问题。现在都在推崇组件化，但组件化的一个问题是有可能多个组件都需要获取同一个资源，如何多个组件中单独请求的话，容易产生冗余请求和资源浪费。

## ModelFactory
为了解决上述的几个问题，我们抽象出一个通用的`factory` -- `ModelFactory`, 它主要做下面几件事情。

1. 添加构造函数`ModelFactory`，其衍生的实例提供`get`、`save`、`update`、`delete`四种资源获取方法，分别代理了`$resource`对应的四种请求方法。
2. 在代理的过程中处理了响应主体的数据，将真正的数据传到下一层。
3. 支持在上述每个方法的代理过程中添加对应的`formatter`和`preFormatter`，只需在具体的实例中添加对应方法即可。
4. 添加资源获取时的Promise对象缓存，缓存时间内的同一种请求返回同一个Promise对象，从而实现在多次资源获取中只有一次请求。

```
(function (angular) {
  angular.module('setting.services')
    .factory('reqSuccessCallback', function($q) {
      return function reqSuccessCallback(event) {
        if (event.status == 200) {
          return $q.when(event.data);
        } else {
          return $q.reject(event.msg);
        }
      }
    })
    .factory('ModelFactory', function (reqSuccessCallback, $q) {
      function ModelFactory (resource) {
        this.resource = resource;
      }

      ModelFactory.prototype.CACHE_DURATION = 5000;

      ModelFactory.prototype._getCacheValidity = function (params) {
        return _.isEqual(this.paramsCache, params) && this.promiseCache 
          && (Date.now() - this.cacheTime <= this.CACHE_DURATION);
      };

      ModelFactory.prototype.get = function (params) {
        var _self = this;
        if (this._getCacheValidity(params)) return this.promiseCache;
        this.paramsCache = params;
        this.cacheTime = Date.now();        
        this.promiseCache = this.resource.get(params || {}).$promise
          .then(reqSuccessCallback)
          .then(function (data) {
            var _formatter = _self.formatterOnGet || _self.formatter || _self._valueFn;
            return $q.when(_formatter(data));
          });
        return this.promiseCache;
      };
      
      ModelFactory.prototype.save = function (params, data) {
        var _self = this;
        var _preFormatter = _self.preFormatterOnSave || _self.preFormatter || _self._valueFn;
        return _save = this.resource.save(params || {}, _preFormatter(data)).$promise
          .then(reqSuccessCallback)
          .then(function (data) {
            var _formatter = _self.formatterOnSaved || _self.formatter || _self._valueFn;
            return $q.when(_formatter(data)); 
          });
      };
      
      ModelFactory.prototype.update = function (params, data) {
        var _self = this;
        var _preFormatter = _self.preFormatterOnUpdate || _self.preFormatter || _self._valueFn;
        return this.resource.update(params || {}, _preFormatter(data)).$promise
          .then(reqSuccessCallback)
          .then(function (data) {
            var _formatter = _self.formatterOnUpdated || _self.formatter || _self._valueFn;
            return $q.when(_formatter(data)); 
          });
      };

      ModelFactory.prototype.delete = function (params) {
        return this.resource.delete(params || {}).$promise
          .then(reqSuccessCallback);
      };

      ModelFactory.prototype._valueFn = function (value) {
        return value;
      };

      return ModelFactory;      
    })
})(angular);
```

