---
title: redis 笔记
date: 2018-12-02 23:43:53
tags: [redis]
---
> 一次讲座的笔记，当然，前面的基础是自己补的。。

# Install
```
brew install redis
brew services start redis
```
# Start
```
redis-server
redis-cli
```
# Base
## String
```
SET name 'yxp'
GET name
DEL name
```

## Hash
```
HMSET person name 'yxp' age 27
HGET person name
HGETALL person
```

## List
```
lpush names yxp
lpush names shawn
lrange names 0 1
```

## Set
```
sadd player kobe
sadd player curry
smembers player
```

## zset
```
zadd [key] [score] [member] # score可理解为权重，将按score降序排序
ZRANGEBYSCORE [key] [start_score] [end_score]
```

## 使用场景
![image.png](https://cdn.nlark.com/lark/0/2018/png/148092/1542254618506-ad11ece7-6cca-4852-ab23-5572c6ce2571.png)



# RDB 持久化
- 手动触发：save(阻塞)、bgsave(fork子进程)
- 自动触发：redis配置、主从同步、debug reload、shutdown

# AOF 
以独立日志写命令，重启时执行AOF文件中的命令恢复数据
- AOF写入 appednonly=yes appendfsync=(always|evetyset|no)
- 重写

# 主从同步
积压缓存区
主从断裂的判断时间

# 集群拓扑结构

# 键分配模式
HASH_SLOT

# cacheCloud

# 应用
## MQ
- 发布订阅
- stream
## 场景
- cache
- 排行榜
- 计数器 HyperLogLog
- 社交网络（微博）
- 消息队列（聊天室）
## 建议
- 专业精细化与简易通用的取舍
- 结合业务场景

## TIPS
- 分布式锁：setex 设置过期时间，避免死锁
- pipeline：一次发送多条命令
- 慢查询：showlog-log-slower-than、showlog-max-len、slowlog get
- Bigkey
- 缓存穿透
- 热点数据
- info

