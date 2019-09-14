---
title: 【一日一题】无重复字符的最长子串
date: 2018-05-24 14:55:19
tags: [一日一题, 算法, leetcode, python, 字符串]
---
**题目描述**
[题目来源](https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/description/)
给定一个字符串，找出不含有重复字符的最长子串的长度。

示例：

给定 "abcabcbb" ，没有重复字符的最长子串是 "abc" ，那么长度就是3。

给定 "bbbbb" ，最长的子串就是 "b" ，长度是1。

给定 "pwwkew" ，最长子串是 "wke" ，长度是3。请注意答案必须是一个子串，"pwke" 是 子序列  而不是子串。

**代码**
```python
class Solution(object):
    def lengthOfLongestSubstring(self, s):
        """
        :type s: str
        :rtype: int
        """
        l = []
        matched = ''
        temp = ''
        for i in s:
            index = temp.find(i)
            if index == -1:
                temp += i
            else:
                if (len(temp) > len(matched)):
                    matched = temp
                temp = temp[index + 1:] + i
        return max(len(matched), len(temp))
```