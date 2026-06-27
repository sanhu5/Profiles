cat > '/etc/sysctl.conf' << EOF
# [#] 基础文件描述符硬限制优化
fs.file-max = 500000
fs.inotify.max_user_instances = 8192

# [#] 网络转发控制 (双栈支持)
net.ipv4.route_localnet = 1
net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1
net.ipv4.conf.default.forwarding = 1
net.ipv6.conf.all.forwarding = 1
net.ipv6.conf.default.forwarding = 1
net.ipv6.conf.lo.forwarding = 1
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0

# [#] 端口范围限制
net.ipv4.ip_local_port_range = 10000 65535

# [#] TCP 基础安全与超时控制
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_tw_reuse = 1

# [#] 连接队列大小控制 (适配 1G 内存，既保并发又不撑爆)
net.ipv4.tcp_max_syn_backlog = 4096
net.core.netdev_max_backlog = 4096
net.core.somaxconn = 2048
net.ipv4.tcp_max_tw_buckets = 20000

# [#] Keepalive 保活优化 (及时清理死连接)
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl = 30

# [#] 现代 TCP 速度优化特性
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_notsent_lowat = 16384

# [#] 内存缓冲区调优 (核心修改：既保证 2G 吞吐，又防止 1G OOM)
# 限制单条 TCP 最大占用约 16MB-32MB 内存
net.core.rmem_max = 33554432
net.core.wmem_max = 33554432
net.ipv4.tcp_rmem = 4096 87380 33554432
net.ipv4.tcp_wmem = 4096 65536 33554432
net.ipv4.udp_rmem_min = 4096
net.ipv4.udp_wmem_min = 4096

# [#] 系统全局网络内存页限制 (4KB 为一页)
# 限制整个网络栈最大占用不超过 300MB 内存
net.ipv4.tcp_mem = 32768 49152 73728

# [#] 拥塞控制算法 (BBR + FQ)
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# [#] 其他常规允许
net.ipv4.ping_group_range = 0 2147483647
EOF

# 应用配置
sysctl -p
