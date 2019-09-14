---
title: 【一日一题】单词拆分
date: 2018-05-24 14:24:31
tags: [一日一题, 算法, leetcode, python, 动态规划]
---
**背景**：
前段时间公司内部拉了一个一日一道算法题的群，虽然坚持不满一个月，但还是蛮有收获的，有些题目还是蛮有意思的，值得马克。

过程过尝试着用`Python`来写，也算是一种修行吧~

**题目描述**：
[题目来源](https://leetcode-cn.com/problems/word-break-ii/description/)

给定一个非空字符串 s 和一个包含非空单词列表的字典 wordDict，在字符串中增加空格来构建一个句子，使得句子中所有的单词都在词典中。返回所有这些可能的句子。

说明：
- 分隔时可以重复使用字典中的单词。
- 你可以假设字典中没有重复的单词。

**代码**：
```python
class Solution:
    def wordBreak(self, s, wordDict, wordMap = None):
        """
        :type s: str
        :type wordDict: List[str]
        :rtype: List[str]
        """
        if wordMap is None:
            wordMap = {}
            wordDict.sort(key = lambda x: -len(x))
        if s in wordMap: 
            return wordMap[s]
        result = []
        for word in wordDict:
            if s == word:
                result.append(s)
            elif s.startswith(word):
                subS = s[len(word):]
                subResult = self.wordBreak(subS, wordDict, wordMap)
                if len(subResult) > 0:
                    result += [word + ' ' + w for w in subResult] 
        wordMap[s] = result
        return result
```