# /bin/sh

CURR=`pwd`
SRC=/usr/local/src
LOG=$CURR/install.log
apt update
# apt install unzip && luarocks -y
apt install unzip -y

mkdir /tmp/ngx_unsafe_log
chmod 777 /tmp/ngx_unsafe_log

# echo "install sqlite3" >> $LOG
# cd /tmp
# wget https://www.sqlite.org/2018/sqlite-autoconf-3260000.tar.gz
# tar -xvf sqlite-autoconf-3260000.tar.gz
# cd sqlite-autoconf-3260000
# ./configure
# make
# make install
# echo "finish" >> $LOG

# echo "init sqlite3 db" >> $LOG
# sqlite3 log.db < $CURR/initdb.sql
# echo "finish" >> $LOG

# luarocks install luasql-sqlite3

cd $SRC
echo "download nginx" >> $LOG
wget http://nginx.org/download/nginx-1.15.7.tar.gz
echo "finish" >> $LOG

echo "download pcre" >> $LOG
wget https://nchc.dl.sourceforge.net/project/pcre/pcre/8.42/pcre-8.42.tar.gz 
echo "finish" >> $LOG

echo "download luajit,ngx_devel_kit (NDK) and lua-nginx-module" >> $LOG
wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz
wget https://github.com/simpl/ngx_devel_kit/archive/v0.3.0.tar.gz
wget wget https://github.com/chaoslawful/lua-nginx-module/archive/v0.10.10.zip
echo "finish" >> $LOG

echo "add user for nginx" >> $LOG
useradd -s /sbin/nologin -M www
echo "finish" >> $LOG


echo "start to uncompress NDK and lua-nginx-module" >> $LOG
tar zxvf v0.3.0.tar.gz
unzip -q v0.10.10.zip
echo "finish" >> $LOG

echo "start to install luajit" >> $LOG
tar zxvf LuaJIT-2.0.5.tar.gz 
cd LuaJIT-2.0.5
make && make install 
echo "finish" >> $LOG

cd $SRC
echo "start install nginx" >> $LOG
tar zxf nginx-1.15.7.tar.gz
tar zxvf pcre-8.42.tar.gz 
cd nginx-1.15.7
export LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.0
./configure --user=www --group=www --prefix=/usr/local/nginx-1.15.7/ --with-pcre=$SRC/pcre-8.42 --with-http_stub_status_module --with-http_sub_module --with-http_gzip_static_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module  --add-module=../ngx_devel_kit-0.3.0/ --add-module=../lua-nginx-module-0.10.10/
make -j2 && make install
ln -s /usr/local/nginx-1.15.7 /usr/local/nginx
ln -s /usr/local/lib/libluajit-5.1.so.2 /lib/libluajit-5.1.so.2
echo "finish" >> $LOG
echo "start to install OpenResty" >> $LOG
sudo apt-get install -y libpcre3-dev libssl-dev perl make build-essential curl

echo "    download OpenResty" >> $LOG
wget https://openresty.org/download/openresty-1.13.6.2.tar.gz
tar zxf openresty-1.13.6.2.tar.gz
cd openresty-1.13.6.2
./configure --prefix=/usr/local/openresty-1.13.6.2 \
--with-luajit --with-http_stub_status_module \
--with-pcre=$SRC/pcre-8.42 --with-pcre-jit
make && make install
ln -s /usr/local/openresty-1.13.6.2 /usr/local/openresty
echo "    finish" >> $LOG
echo "finish" >> $LOG


#测试openresty安装
# vim /usr/local/openresty/nginx/conf/nginx.conf
# server {
#     location /hello {
#             default_type text/html;
#             content_by_lua_block {
#                 ngx.say("HelloWorld")
#             }
#         }
# }
# /usr/local/openresty-1.13.6.2/nginx/sbin/nginx -t
#nginx: the configuration file /usr/local/openresty-1.13.6.2/nginx/conf/nginx.conf syntax is ok
#nginx: configuration file /usr/local/openresty-1.13.6.2/nginx/conf/nginx.conf test is successful
# /usr/local/openresty/nginx/sbin/nginx
#Hello World
# curl http://127.0.0.1/hello
#HelloWorld

cp -a $CURR/waf /usr/local/openresty/nginx/conf/
cp $CURR/dist/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

echo "boot openresty" >>$LOG
sudo /usr/local/openresty/nginx/sbin/nginx -t
sudo /usr/local/openresty/nginx/sbin/nginx
echo "success" >> $LOG


echo "install django" >> $LOG
apt install python3 python3-pip -y
cd ~
mkdir .pip
echo "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple/\n" > ./.pip/pip.conf
pip3 install django
echo "finish" >> $LOG

echo "boot web log" >> $LOG
cd $CURR/webview
nohup python3 manage.py runserver &
echo "finish" >> $LOG


print "OK
攻击测试：
    读敏感文件：
        http://127.0.0.1/.bash_history
    访问敏感页面：
        http://127.0.0.1/phpmyadmin
    url参数sql注入：
        http://192.168.30.82/?test=select%20from
    url参数xss：
        http://192.168.30.82/?test=<script>%20alert("xss")</script>
    扫描器防护：
        sqlmap、netsaprker等漏洞扫描器拦截，安装后对测试页面测试即可

日志查看：
    http://127.0.0.1:8000
"