---
title: 大数相乘
date: 2018-08-09 19:21:39
tags: [算法, 面试]
---
> 面试的时候被问了大数相加的问题，马克一下吧~ 顺便试下大数相乘。
# 大数相加
```
function add(n1, n2) {
  const a1 = n1.split('').reverse();
  const a2 = n2.split('').reverse();
  const result = [];
  for (let i = 0, l = Math.max(a1.length, a2.length); i < l; i++) {
    result[i] = (result[i] || 0) + parseInt(a1[i] || 0) + parseInt(a2[i] || 0);
    while (result[i] >= 10) {
      result[i] -= 10;
      result[i + 1] = (result[i + 1] || 0) + 1;
    }
  }
  return result.reverse().join('');
}
```
# 大数相乘
```
function multiply(n1, n2) {
  const a1 = n1.split('').reverse();
  const a2 = n2.split('').reverse();
  const result = [];
  for (let i = 0, l1 = a1.length; i < l1; i++) {
    for (let j = 0, l2 = a2.length; j < l2; j++) {
      result[i + j] = (result[i + j] || 0) + a1[i] * a2[j];
      while (result[i + j] >= 10) {
        result[i + j] -= 10;
        result[i + j + 1] = (result[i + j + 1] || 0) + 1;
      }
    }
  }
  return result.reverse().join('');
}
```
