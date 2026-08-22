# apine
tar -xzf rss_venv.tar.gz
tar -xzf rss_venv.tar.gz -C /root/rss/
rm -f *venv.tar.gz*

# 创建 GPT bot 的自启服务
cat > /etc/init.d/gpt-bot << 'EOF'
#!/sbin/openrc-run

name="GPT Telegram Bot"
description="GPT AI Bot Service"
command="/root/rss/rss_venv/bin/python"
command_args="/root/rss/gpt.py"
command_user="root"
command_background=true
pidfile="/run/gpt-bot.pid"
#output_log="/root/rss/gpt.log"
#error_log="/root/rss/gpt.log"

depend() {
    need net
    after firewall
}

start_pre() {
    sleep 10
}
EOF

chmod +x /etc/init.d/gpt-bot
# 启动服务
rc-service gpt-bot start
# 加入开机自启
rc-update add gpt-bot default

rc-service gpt-bot start     # 启动
rc-service gpt-bot stop      # 停止
rc-service gpt-bot restart   # 重启
rc-service gpt-bot status    # 查看状态
tail -f /root/rss/gpt.log    # 看日志