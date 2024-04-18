#!/bin/bash

# Tải xuống và cài đặt các script
/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/bm-find-os https://raw.githubusercontent.com/fviatool/squid-proxy/main/bm-find-os.sh
chmod 755 /usr/local/bin/bm-find-os

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/squid-uninstall https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-uninstall.sh
chmod 755 /usr/local/bin/squid-uninstall

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/squid-add-user https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-add-user.sh
chmod 755 /usr/local/bin/squid-add-user

# Kiểm tra xem script bm-find-os đã được tải xuống chưa
if [ ! -f /usr/local/bin/bm-find-os ]; then
    echo "/usr/local/bin/bm-find-os không tìm thấy"
    exit 1
fi

# Lấy thông tin hệ điều hành
BM_OS=$(/usr/local/bin/bm-find-os)

# Cài đặt Squid Proxy tùy theo hệ điều hành
if [ $BM_OS == "ubuntu" ]; then
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
elif [ $BM_OS == "debian" ] || [ $BM_OS == "debian12" ]; then
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid > /dev/null 2>&1
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-debian.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl restart squid
    systemctl enable squid
elif [ $BM_OS == "centos7" ] || [ $BM_OS == "centos8" ] || [ $BM_OS == "almalinux8" ] || [ $BM_OS == "almalinux9" ]; then
    yum install squid -y
    mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-centos.conf
    systemctl restart squid
    systemctl enable squid
fi

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${NC}"
echo -e "${GREEN}Cảm ơn bạn đã sử dụng ServerOk Squid Proxy Installer.${NC}"
echo
echo -e "${CYAN}Để tạo người dùng proxy, chạy lệnh: squid-add-user${NC}"
echo -e "${CYAN}Để thay đổi cổng proxy squid!"
echo -e "${NC}"
