#!/bin/bash


if [ `whoami` != root ]; then
	echo "ERROR: You need to run the script as user root or add sudo before command."
	exit 1
fi

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/bm-find-os https://raw.githubusercontent.com/fviatool/squid-proxy/main/bm-find-os.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/bm-find-os

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/squid-uninstall https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-uninstall.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/squid-uninstall

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/squid-add-user https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-add-user.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/squid-add-user

if [[ -d /etc/squid/ || -d /etc/squid3/ ]]; then
    echo "Squid Proxy already installed. If you want to reinstall, first uninstall squid proxy by running command: squid-uninstall"
    exit 1
fi

if [ ! -f /usr/local/bin/bm-find-os ]; then
    echo "/usr/local/bin/bm-find-os not found"
    exit 1
fi

BM_OS=$(/usr/local/bin/bm-find-os)

if [ $BM_OS == "ERROR" ]; then
    echo "OS NOT SUPPORTED.\n"
    exit 1;
fi

if [ $BM_OS == "ubuntu2204" ]; then
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
elif [ $BM_OS == "ubuntu2004" ]; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid > /dev/null 2>&1
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl restart squid
    systemctl enable squid
elif [ $BM_OS == "ubuntu1804" ]; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid3 > /dev/null 2>&1
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl restart squid
    systemctl enable squid
elif [ $BM_OS == "ubuntu1604" ]; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid3 > /dev/null 2>&1
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl restart squid
    systemctl enable squid
elif [ $BM_OS == "ubuntu1404" ]; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid3 > /dev/null 2>&1
    /bin/rm -f /etc/squid3/squid.conf
    /usr/bin/touch /etc/squid3/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid3/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl restart squid3
    systemctl enable squid3
elif [ $BM_OS == "debian8" ]; then
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid3 > /dev/null 2>&1
    /usr/bin/touch /etc/squid3/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid3/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl restart squid3
    systemctl enable squid3
elif [ $BM_OS == "debian9" ]; then
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid > /dev/null 2>&1
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid
    systemctl restart squid
elif [ $BM_OS == "debian10" ]; then
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid > /dev/null 2>&1
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid
    systemctl restart squid
elif [ $BM_OS == "debian11" ]; then
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid > /dev/null 2>&1
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid
    systemctl restart squid
elif [ $BM_OS == "debian12" ]; then
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install squid  > /dev/null 2>&1
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/conf.d/serverok.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/debian12.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid
    systemctl restart squid
elif [ $BM_OS == "centos7" ]; then
    yum install squid -y
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-centos7.conf
    systemctl enable squid
    systemctl restart squid
    if [ -f /usr/bin/firewall-cmd ]; then
    firewall-cmd --zone=public --permanent --add-port=3128/tcp > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    fi
elif [ "$BM_OS" == "centos8" ] || [ "$BM_OS" == "almalinux8" ] || [ "$BM_OS" == "almalinux9" ]; then
    yum install squid wget -y
    mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-centos7.conf
    systemctl enable squid
    systemctl restart squid
    if [ -f /usr/bin/firewall-cmd ]; then
    firewall-cmd --zone=public --permanent --add-port=3128/tcp > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    fi
elif [ "$BM_OS" == "centos8s" ]; then
    dnf install squid wget -y > /dev/null 2>&1
    mv /etc/squid/squid.conf /etc/squid/squid.conf.bak 
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-centos7.conf
    systemctl enable squid  > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    if [ -f /usr/bin/firewall-cmd ]; then
    firewall-cmd --zone=public --permanent --add-port=3128/tcp > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    fi
elif [ "$BM_OS" == "centos9" ]; then
    dnf install squid wget -y > /dev/null 2>&1
    mv /etc/squid/squid.conf /etc/squid/squid.conf.sok
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-centos7.conf
    systemctl enable squid  > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    if [ -f /usr/bin/firewall-cmd ]; then
    firewall-cmd --zone=public --permanent --add-port=3128/tcp > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    fi
fi

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${NC}"
echo -e "${GREEN}Thank you for using ServerOk Squid Proxy Installer.${NC}"
echo
echo -e "${CYAN}To create a proxy user, run command: squid-add-user${NC}"
echo -e "${CYAN}To change squid proxy port!"
echo -e "${NC}"
