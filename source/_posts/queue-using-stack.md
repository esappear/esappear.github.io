---
title: 用栈模拟队列
date: 2018-08-09 19:47:37
tags: [算法, 栈, 队列, 面试]
---
> 又是一道被面试题，虽然据说是基础题，但是方法还是很巧妙，值得马克。

```js
class Stack {
  constructor() {
    this.stack = [];
  }
  pop () {
    return this.stack.pop();
  }
  push (...args) {
    this.stack.push(...args);
  }
}

class Queue {
  constructor() {
    this.inStack = new Stack;
    this.outStack = new Stack;
  }
  enqueue(...args) {
    this.inStack.push(...args);
  }
  dequeue() {
    let res = this.outStack.pop();
    if (typeof res === 'undefined') {
      let temp = this.inStack.pop();
      while (typeof temp !== 'undefined') {
        this.outStack.push(temp);
        temp = this.inStack.pop();
      }
      res = this.outStack.pop();
    }
    return res;
  }
}
```
