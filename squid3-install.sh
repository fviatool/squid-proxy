#!/bin/bash

if [ `whoami` != root ]; then
	echo "ERROR: Bạn cần chạy script với quyền root hoặc thêm sudo trước lệnh."
	exit 1
fi

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/bm-find-os https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/bm-find-os.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/bm-find-os

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/squid-uninstall https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid-uninstall.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/squid-uninstall

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/squid-add-user https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid-add-user.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/squid-add-user

if [[ -d /etc/squid/ || -d /etc/squid3/ ]]; then
    echo "Squid Proxy đã được cài đặt. Nếu bạn muốn cài đặt lại, hãy gỡ cài đặt squid proxy trước bằng lệnh: squid-uninstall"
    exit 1
fi

if [ ! -f /usr/local/bin/bm-find-os ]; then
    echo "/usr/local/bin/bm-find-os không tìm thấy"
    exit 1
fi

BM_OS=$(/usr/local/bin/bm-find-os)

if [ $BM_OS == "ERROR" ]; then
    echo "HỆ ĐIỀU HÀNH KHÔNG ĐƯỢC HỖ TRỢ.\n"
    echo "Liên hệ https://xpresservers.com/contact để được hỗ trợ thêm cho hệ điều hành của bạn."
    exit 1;
fi

if [ $BM_OS == "ubuntu2204" ]; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid > /dev/null 2>&1
    mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/conf/ubuntu-2204.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl restart squid
    systemctl enable squid
elif [ $BM_OS == "debian11" ] || [ $BM_OS == "debian12" ]; then
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid > /dev/null 2>&1
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/conf/squid-debian.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl restart squid
    systemctl enable squid
elif [ $BM_OS == "centos7" ] || [ $BM_OS == "centos8" ] || [ $BM_OS == "almalinux8" ] || [ $BM_OS == "almalinux9" ]; then
    yum install squid -y
    mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/conf/squid-centos.conf
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