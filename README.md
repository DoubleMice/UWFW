# UWFW
Ugly Web FireWall

### 架构
```
                    |-------------------|
                    |                   |
admin<------monitor server              |
                                        |
                                        |
                        (is attacker)   |
someone--------->server-------------->attack_log
                    |
                    |   (not attacker)
                    |---------------->web resources
```


* waf部分：lua-nginx-module(openresty)
* log部分：lua
* web部分：django后端

## 目录结构
```
doublemice@DoubleMice-MBP:~/Desktop/UWFW|master⚡ 
⇒  tree
.
├── README.md
├── dist
│   └── nginx.conf          ------------ 测试用的conf配置
├── install.sh              ------------ 一键安装脚本
├── waf
│   ├── access.lua
│   ├── config.lua
│   ├── init.lua
│   ├── lib.lua
│   └── rule-config         ------------ 防火墙规则
│       ├── args.rule
│       ├── blackip.rule
│       ├── cookie.rule
│       ├── post.rule
│       ├── url.rule
│       ├── useragent.rule
│       ├── whiteip.rule
│       └── whiteurl.rule
└── webview                 ------------ web日志监控
    ├── manage.py
    ├── templates
    │   └── index.html
    └── webview
        ├── __init__.py
        ├── __pycache__
        │   ├── __init__.cpython-37.pyc
        │   ├── settings.cpython-37.pyc
        │   ├── urls.cpython-37.pyc
        │   ├── view.cpython-37.pyc
        │   ├── views.cpython-37.pyc
        │   └── wsgi.cpython-37.pyc
        ├── settings.py
        ├── urls.py
        ├── view.py
        └── wsgi.py

7 directories, 28 files
```


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

django后端，监控log文件并输出到web端。


## 平台

ubuntu16.04 + openresty


## 注意事项

### 一些命令
```sh
# 查看nginx进程
ps aux|grep nginx
# 关闭nginx测试服务器
sudo /usr/local/openresty/nginx/sbin/nginx
# 开启web日志服务器
python3 manage.py runserver
```

### 说明

如需要修改规则，则进入相应目录：/usr/local/openresty/nginx/conf/waf/rule-config
目录文件如下
```
├── args.rule
├── blackip.rule
├── cookie.rule
├── post.rule
├── url.rule
├── useragent.rule
├── whiteip.rule
└── whiteurl.rule
```
修改相应文件中规则即可。

举例：添加ip白名单

在whiteip.rule文件中加入指定ip，然后重启nginx测试服务器。

