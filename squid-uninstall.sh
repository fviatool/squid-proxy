#!/bin/bash

##################################################################
# Easy Squid Proxy Uninstaller
# Author: BashMail
# Email: support@bashmail.net
# Github: https://github.com/bashmail/Easy-Squid-Proxy-Installer/
# Web: https://xpresservers.com
# If you need professional assistance, reach out to
# https://xpresservers.com/contact
##################################################################

if [ `whoami` != root ]; then
	echo "ERROR: You need to run the script as user root or add sudo before command."
	exit 1
fi

if [ ! -f /usr/local/bin/bm-find-os ]; then
    echo "/usr/local/bin/bm-find-os not found"
    exit 1
fi

BM_OS=$(/usr/local/bin/bm-find-os)

if [ $BM_OS == "ERROR" ]; then
    echo "OS NOT SUPPORTED.\n"
    echo "Contact https://xpresservers.com/contact to add support for your OS."
    exit 1;
fi

if [ $BM_OS == "ubuntu2204" ]; then
    /usr/bin/apt -y remove --purge squid squid-common squid-langpack
    rm -rf /etc/squid/
elif [ $BM_OS == "ubuntu2004" ]; then
    /usr/bin/apt -y remove --purge squid*
    rm -rf /etc/squid/
elif [ $BM_OS == "ubuntu1804" ]; then
    /usr/bin/apt -y remove --purge squid3
    /bin/rm -rf /etc/squid/
elif [ $BM_OS == "ubuntu1604" ]; then
    /usr/bin/apt -y remove --purge squid3
    /bin/rm -rf /etc/squid3/
    /bin/rm -rf /etc/squid/
elif [ $BM_OS == "ubuntu1404" ]; then
    /usr/bin/apt remove --purge squid3 -y
    /bin/rm -rf /etc/squid3/
    /bin/rm -rf /etc/squid/
elif [ $BM_OS == "debian8" ]; then
    /usr/bin/apt -y remove --purge squid
    /bin/rm -rf /etc/squid3/
    /bin/rm -rf /etc/squid/
elif [ $BM_OS == "debian9" ]; then
    /usr/bin/apt -y remove --purge squid
    /bin/rm -rf /etc/squid/
    /bin/rm -rf /var/spool/squid
elif [ $BM_OS == "debian10" ]; then
    /usr/bin/apt -y remove --purge squid squid-common squid-langpack
    /bin/rm -rf /etc/squid/
    /bin/rm -rf /var/spool/squid
elif [ $BM_OS == "debian11" ]; then
    /usr/bin/apt -y remove --purge squid squid-common squid-langpack
    /bin/rm -rf /etc/squid/
    /bin/rm -rf /var/spool/squid
elif [ $BM_OS == "debian12" ]; then
    /usr/bin/apt -y remove --purge squid squid-common squid-langpack
    /bin/rm -rf /etc/squid/
    /bin/rm -rf /var/spool/squid
elif [ $BM_OS == "centos7" ]; then
    yum remove squid -y
    /bin/rm -rf /etc/squid/
elif [ "$BM_OS" == "centos8" ] || [ "$BM_OS" == "almalinux8" ] || [ "$BM_OS" == "almalinux9" ]; then
    yum remove squid -y
    /bin/rm -rf /etc/squid/
elif [ "$BM_OS" == "centos8s" ]; then
    dnf remove squid -y
    /bin/rm -rf /etc/squid/
elif [ "$BM_OS" == "centos9" ]; then
    dnf remove squid -y
    /bin/rm -rf /etc/squid/
fi

rm -f /usr/local/bin/squid-add-user > /dev/null 2>&1
rm -f /root/squid3-install.sh > /dev/null 2>&1
rm -f /usr/local/bin/bm-find-os > /dev/null 2>&1
rm -f /usr/local/bin/squid-uninstall > /dev/null 2>&1

echo 
echo 
echo "Squid Proxy uninstalled."
echo "Thank youfor using BashMail squid proxy installer”
echo "If you want to reinstall Squid Proxy Server"
echo