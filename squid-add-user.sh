#!/bin/bash

##################################################################
# Easy Squid Proxy Installer
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

if [ ! -f /usr/bin/htpasswd ]; then
    echo "htpasswd not found"
    exit 1
fi

if [ -f /etc/squid/passwd ]; then
    /usr/bin/htpasswd /etc/squid/passwd
else
    /usr/bin/htpasswd -c /etc/squid/passwd
fi

systemctl reload squid > /dev/null 2>&1
service squid3 restart > /dev/null 2>&1