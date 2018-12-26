--WAF config file,enable = "on",disable = "off"

--waf status
config_waf_enable = "on"
--log dir
config_log_dir = "/tmp/ngx_unsafe_log"
--rule setting
config_rule_dir = "/usr/local/openresty/nginx/conf/waf/rule-config"
--enable/disable white url
config_white_url_check = "on"
--enable/disable white ip
config_white_ip_check = "on"
--enable/disable block ip
config_black_ip_check = "on"
--enable/disable url filtering
config_url_check = "on"
--enalbe/disable url args filtering
config_url_args_check = "on"
--enable/disable user agent filtering
config_user_agent_check = "on"
--enable/disable cookie deny filtering
config_cookie_check = "on"
--enable/disable cc filtering
config_cc_check = "on"
--cc rate the xxx of xxx seconds
config_cc_rate = "10/60"
--enable/disable post filtering
config_post_check = "on"
--config waf output redirect/html
config_waf_output = "html"
--if config_waf_output ,setting url
config_waf_redirect_url = "https://www.unixhot.com"
config_output_html=[[
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="zh-cn" />
<title>web防火墙</title>
</head>
<body>
<p align="center">这是一个危险操作，你的信息已被记录0.0</p>  <br>
<p align="center">By: 信息安全综合实验 web防火墙 小组</p>  <br>
<p align="center">组员：梁志浩、鲁国亮、肖逸明 。</p>
</body>
</html>
]]

