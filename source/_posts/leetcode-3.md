---
title: 【一日一题】删除二叉搜索树中的节点
date: 2018-05-24 14:48:37
tags: [一日一题, 算法, leetcode, python, 树]
---
**题目描述**
[题目来源](https://leetcode-cn.com/problems/delete-node-in-a-bst/description/)
给定一个二叉搜索树的根节点 root 和一个值 key，删除二叉搜索树中的 key 对应的节点，并保证二叉搜索树的性质不变。返回二叉搜索树（有可能被更新）的根节点的引用。

一般来说，删除节点可分为两个步骤：

首先找到需要删除的节点；
如果找到了，删除它。
说明： 要求算法时间复杂度为 O(h)，h 为树的高度。


**代码**
```
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def deleteNode(self, root, key):
        """
        :type root: TreeNode
        :type key: int
        :rtype: TreeNode
        """
        parent = None
        selected = None
        current = root
        while current:
            if current.val == key:
                selected = current
                break
            elif current.val > key:
                if not current.left:
                    break
                parent = current
                current = current.left
            else:
                if not current.right:
                    break
                parent = current
                current = current.right
        if not selected:
            return root
        newSelected = self.rebuildTree(selected.left, selected.right)
        if parent:
            if parent.val > selected.val:
                parent.left = newSelected
            else:
                parent.right = newSelected
        return root if parent else newSelected
    
    def rebuildTree(self, left, right):
        if not left:
            return right
        if not right:
            return left
        current = right
        while current.left:
            current = current.left
        current.left = left
        return right
```