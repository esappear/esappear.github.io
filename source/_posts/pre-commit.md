---
title: 利用pre-commit对js代码进行eslint检查
date: 2018-06-28 17:09:06
tags: [pre-commit, git, shell, eslint]
---
**背景**：项目中有两个子前端项目，分别是`Gulp` + `Angular.js` 和 `Vue` + `Webpack`。两个项目有各自的eslint插件和规则。

**需求**：要在项目中添加`pre-commit`钩子，对每次提交中有改动的js或vue文件进行eslint检查。由于历史原因，不要对项目中的所有js文件进行检查。

**调研**：钩子其实是`git`提供的，只要在项目的根目录的`.git/hooks`中添加`pre-commit`脚本即可。至于怎么添加脚本，以及添加什么解释器的脚本，就八仙过海各显神通了。

**方案**：在项目根目录下用npm安装`pre-commit`，该命令会在当前目录的`.git/hooks`中添加`pre-commit`脚本。我们需要在根目录的`package.json`中指明`pre-commit`阶段具体执行的脚本。代码如下：

```
{
  "scripts": {
    "lintAdmin": "git status -s | grep -E '^[MARC][^D].+fe_build/apps/web_admin/src/.*\\.js$' | rev | cut -d ' ' -f 1 | rev | xargs fe_build/apps/web_admin/node_modules/eslint/bin/eslint.js",
    "lintMobile": "git status -s | grep -E '^[MARC][^D].+fe_build/apps/mobile_v2/src/.*\\.(js|vue)$' | rev | cut -d ' ' -f 1 | rev | xargs fe_build/apps/mobile_v2/node_modules/eslint/bin/eslint.js"
  },
  "pre-commit": [
    "lintMobile",
    "lintAdmin"
  ],
  "devDependencies": {
    "pre-commit": "^1.2.2"
  }
}
```
**关键点**
**git status**
反应了当前工作区和暂存区的文件状态，使用`git status -s`可以输出`XY PATH`或`XY ORIG_PATH -> PATH`（仅对重命名和复制的文件有用）格式的多行内容。其中，`XY`表示的含义在处理冲突的时候分别表示的是两个分支的文件状态，在非处理冲突的时候分别表示暂存区和工作区的文件状态。

下面是从官网摘下来的状态详细说明：
非处理冲突时

X | Y | Meaning
-- | -- | --
 | [AMD] | not updated
M | [ MD] | updated in index
A | [ MD] | added to index
D |       | deleted from index
R | [ MD] | renamed in index
C | [ MD] | copied in index
[MARC] |  | index and work tree matches
[ MARC] | M | work tree changed since index
[ MARC] | D | deleted in work tree
[ D] | R | renamed in work tree
[ D] | C | copied in work tree

处理冲突时

X | Y | Meaning
-- | -- | --
D | D | unmerged, both deleted
A | U | unmerged, added by us
U | D | unmerged, deleted by them
U | A | unmerged, added by them
D | U | unmerged, deleted by us
A | A | unmerged, both added
U | U | unmerged, both modified

其他情况

X | Y | Meaning
-- | -- | --
? | ? | untracked
! | ! | ignored

其中，

  | M | A | D | R | C | U
-- | -- | -- | -- | -- | -- | -- 
unmodified | modified | added | deleted | renamed | copied | updated but unmerged

**grep**
`grep -E `后面可以加正则表达式，对输入的行进行正则匹配。

**rev**
`rev` 可以使内容翻转，由此可以通过`cut`命令读到剪切完的最后一个`field`。因为`git status -s`输出的内容格式有两种（`XY PATH`和`XY ORIG_PATH -> PATH`），从而使得`cut -d ' ' -f 1`的裁剪结果的分组数是不一样的，但是明显最后一个PATH才是我们需要匹配的。

**`[MARC][^D]`**
由于对已删除的文件进行eslint检查是会报错的，所以我们需要过滤掉已删除的文件。

对于非merge的情况，`X`代表暂存区的文件状态，`Y`代表工作区的文件状态，因而`[MARC][^D]`表示在暂存区中修改、添加、重命名或复制过，且在工作区中没有被删除的文件。

PS: `cut`和`xargs`真是好东西啊~

**后记**
后来发现`git diff --cached --name-only --diff-filter ACMR`可以直接输出暂存区中`ACMR`状态的文件。这个跟我手写的唯一区别应该在于加入暂存区的文件在工作区被删除的情况了，这个版本还是会去对已删除的文件进行eslint检查从而报错，我的版本会过滤掉这样的文件。

由此，`package.json`可被修正成：
```
{
  "scripts": {
    "lintAdmin": "git diff --cached --name-only --diff-filter ACMR | grep -E 'fe_build/apps/web_admin/src/.*\\.js$' | xargs fe_build/apps/web_admin/node_modules/eslint/bin/eslint.js",
    "lintMobile": "git diff --cached --name-only --diff-filter ACMR | grep -E 'fe_build/apps/mobile_v2/src/.*\\.(js|vue)$' | xargs fe_build/apps/mobile_v2/node_modules/eslint/bin/eslint.js"
  },
  "pre-commit": [
    "lintMobile",
    "lintAdmin"
  ],
  "devDependencies": {
    "pre-commit": "^1.2.2"
  }
}
```

噗~