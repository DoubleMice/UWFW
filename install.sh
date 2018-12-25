# /bin/sh

#apt install unzip -y
PWD=`pwd`
SRC=/usr/local/src
LOG=$PWD/install.log

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
echo "finish"


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

cp -a $PWD/waf /usr/local/openresty/nginx/conf/

echo "boot openresty" 
sudo /usr/local/openresty/nginx/sbin/nginx -t
sudo /usr/local/openresty/nginx/sbin/nginx
echo "success"