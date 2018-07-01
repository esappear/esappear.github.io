---
title: 【一日一题】不用额外空间的数组去重
date: 2018-05-24 14:46:13
tags: [一日一题, 算法, leetcode, python, 数组]
---
**题目描述**：
[题目来源](https://leetcode-cn.com/problems/find-all-duplicates-in-an-array/description/)
给定一个整数数组 a，其中1 ≤ a[i] ≤ n （n为数组长度）, 其中有些元素出现两次而其他元素出现一次。

找到所有出现两次的元素。

你可以不用到任何额外空间并在O(n)时间复杂度内解决这个问题吗？

**代码**
```
class Solution:
    def findDuplicates(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        result = []
        for i in nums:
            index = abs(i) - 1
            if nums[index] < 0:
                result.append(abs(i))
            else:
                nums[index] = -nums[index]
        return result
```