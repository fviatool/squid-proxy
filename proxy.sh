#!/bin/bash

# Hàm để cài đặt Squid Proxy
installSquidProxy() {
    if [[ "$OS" = "CentOS Linux" ]]; then
        yum install -y squid > /dev/null
    elif [[ "$OS" = "Ubuntu" ]]; then
        apt-get install -y squid > /dev/null
    fi
}

# Hàm để cấu hình Squid Proxy với IPv6
configureSquidProxy() {
    squid_conf="/etc/squid/squid.conf"
    echo "
    acl localnet src fc00::/7       # RFC 4193 local private network range
    acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
    acl localnet src fe50::/10      # RFC 7346 overlay-created link-local network
    acl localnet src fd00::/8       # RFC 4193 local private network range
    acl SSL_ports port 443
    acl Safe_ports port 80          # http
    acl Safe_ports port 21          # ftp
    acl Safe_ports port 443         # https
    acl Safe_ports port 70          # gopher
    acl Safe_ports port 210         # wais
    acl Safe_ports port 1025-65535  # unregistered ports
    acl Safe_ports port 280         # http-mgmt
    acl Safe_ports port 488         # gss-http
    acl Safe_ports port 591         # filemaker
    acl Safe_ports port 777         # multiling http
    acl CONNECT method CONNECT
    http_access allow manager localhost
    http_access deny manager
    http_access allow localhost
    http_access deny all
    http_port [::]:3128
    coredump_dir /var/spool/squid
    refresh_pattern ^ftp:           1440    20%     10080
    refresh_pattern ^gopher:        1440    0%      1440
    refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
    refresh_pattern .               0       20%     4320" >> "$squid_conf"
}

# Hàm để tạo ra 1000 proxy từ các cổng khác nhau với IPv4 mặc định
createSquidProxies() {
    squid_conf="/etc/squid/squid.conf"
    for ((port=3128; port<=4127; port++)); do
        echo "http_port $port" >> "$squid_conf"
        echo "192.168.1.10:$port" >> "ip_ports.txt"
    done
}

# Hàm để cấp quyền truy cập đầy đủ cho tệp văn bản
setFilePermissions() {
    chmod 777 ip_ports.txt
}

# Hàm để khởi động Squid Proxy
startSquidProxy() {
    systemctl start squid
    systemctl enable squid
}

# Chương trình chính
main() {
    installSquidProxy
    configureSquidProxy
    createSquidProxies
    setFilePermissions
    startSquidProxy
}

# Chạy chương trình chính
mainp
