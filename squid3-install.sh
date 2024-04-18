#!/bin/bash

# Tải xuống và cài đặt các script
/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/bm-find-os https://raw.githubusercontent.com/fviatool/squid-proxy/main/bm-find-os.sh
chmod 755 /usr/local/bin/bm-find-os

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/squid-uninstall https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-uninstall.sh
chmod 755 /usr/local/bin/squid-uninstall

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/squid-add-user https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-add-user.sh
chmod 755 /usr/local/bin/squid-add-user

# Cài đặt Squid Proxy
/usr/bin/apt update > /dev/null 2>&1
/usr/bin/apt -y install squid > /dev/null 2>&1
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
/usr/bin/touch /etc/squid/blacklist.acl
/usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/ubuntu-2204.conf
if [ -f /sbin/iptables ]; then
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
fi
systemctl restart squid
systemctl enable squid

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${NC}"
echo -e "${GREEN}Cảm ơn bạn đã sử dụng ServerOk Squid Proxy Installer.${NC}"
echo
echo -e "${CYAN}Để tạo người dùng proxy, chạy lệnh: squid-add-user${NC}"
echo -e "${CYAN}Để thay đổi cổng proxy squid!"
echo -e "${NC}"
