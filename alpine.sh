# apine
apk add git
git clone https://github.com/penggan00/gpt.git
tar -xzf /root/rss/rss_venv.tar.gz -C /root/rss/
rm -rf /root/rss/rss_venv.tar.gz
python3 -m venv rss_venv
# 创建 gpt bot 的自启服务
cat > /etc/init.d/gpt-bot << 'EOF'
#!/sbin/openrc-run

name="gpt Telegram Bot"
description="gpt AI Bot Service"

# 使用 start-stop-daemon 管理进程
command="/root/rss/rss_venv/bin/python"
command_args="/root/rss/gpt.py"
command_user="root"
command_background=true
pidfile="/run/gpt-bot.pid"

# 日志配置（取消注释即可启用）
#output_log="/root/rss/gpt.log"
#error_log="/root/rss/gpt.log"

depend() {
    need net
    after firewall
}

# 确保目录存在
start_pre() {
    mkdir -p /root/rss
    sleep 2
}

# 停止时清理
stop_post() {
    rm -f /run/gpt-bot.pid
}
EOF

chmod +x /etc/init.d/gpt-bot
# 开机自启
rc-update add gpt-bot default
# 重启服务
rc-service gpt-bot restart
# 查看状态
rc-service gpt-bot status


# 启动服务
rc-service gpt-bot start
# 停止服务
rc-service gpt-bot stop
# 取消开机自启
rc-update del gpt-bot default
# 查看实时日志
tail -f /root/rss/gpt.log




