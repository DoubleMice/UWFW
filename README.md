# UWFW
Ugly Web FireWall

* waf部分：lua-nginx-module(openresty)
* log部分：lua_mysql
* web部分：django后端 + vue.js前端

## waf部分

参考[waf](https://github.com/unixhot/waf)

使用openresty的lua拓展，给nginx服务器添加web应用防火墙。

### 部署

``` sh
chmod +x install.sh
sudo ./install.sh
```


### 功能
1. 支持IP白名单和黑名单功能，直接将黑名单的IP访问拒绝。
1. 支持URL白名单，将不需要过滤的URL进行定义。
1. 支持User-Agent的过滤，匹配自定义规则中的条目，然后进行处理（返回403）。
1. 支持CC攻击防护，单个URL指定时间的访问次数，超过设定值，直接返回403。
1. 支持Cookie过滤，匹配自定义规则中的条目，然后进行处理（返回403）。
1. 支持URL过滤，匹配自定义规则中的条目，如果用户请求的URL包含这些，返回403。
1. 支持URL参数过滤，原理同上。
1. 支持日志记录，将所有拒绝的操作，记录到日志中去。
1. 日志记录为JSON格式，便于日志分析，例如使用ELKStack进行攻击日志收集、存储、搜索和展示。



## log部分

使用openresty的lua拓展lua-mysql，将waf部分的非法操作写入数据库。

## web监控部分

### 部署

### django后端

### vue.js前端