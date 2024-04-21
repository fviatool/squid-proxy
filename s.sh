#!/usr/bin/env bash

echo "=========== Install Required Packages ================="
yum -y groupinstall 'Development Tools'
yum install -y perl gcc autoconf automake make sudo wget libxml2-devel libcap-devel libtool-ltdl-devel install gcc-c++
yum -y install python3 python3-pip

# Install pip if not installed
if ! command -v pip3 &> /dev/null
then
    echo "Pip not found, installing pip..."
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    rm get-pip.py
else
    echo "Pip is already installed."
fi

echo "=========== Re Compile Squid With Custom Configuration Params ================="
cd /opt
mkdir youni_ipv4_to_ipv6
cd youni_ipv4_to_ipv6
wget -c https://raw.githubusercontent.com/abdelyouni/ipv4_to_ipv6/main/gen_squid_conf.py
wget -c http://www.squid-cache.org/Versions/v4/squid-4.17.tar.gz
tar -zxvf squid-4.17.tar.gz
cd squid-4.17
./configure 'CXXFLAGS=-DMAXTCPLISTENPORTS=50000' \
--build=x86_64-redhat-linux-gnu \
--host=x86_64-redhat-linux-gnu \
--program-prefix= \
--disable-dependency-tracking \
--prefix=/usr \
--exec-prefix=/usr \
--bindir=/usr/bin \
--sbindir=/usr/sbin \
--sysconfdir=/etc \
--datadir=/usr/share \
--includedir=/usr/include \
--libdir=/usr/lib64 \
--libexecdir=/usr/libexec \
--localstatedir=/var \
--sharedstatedir=/var/lib \
--mandir=/usr/share/man \
--infodir=/usr/share/info \
--exec_prefix=/usr \
--libexecdir=/usr/lib64/squid \
--localstatedir=/var \
--datadir=/usr/share/squid \
--sysconfdir=/etc/squid \
--with-logdir=/var/log/squid \
--with-pidfile=/var/run/squid.pid \
--disable-dependency-tracking \
--enable-follow-x-forwarded-for \
--enable-auth \
--enable-auth-basic=DB,LDAP,NCSA,NIS,POP3,RADIUS,SASL,SMB,getpwnam,fake \
--enable-auth-ntlm=fake \
--enable-auth-digest=file,LDAP,eDirectory \
--enable-auth-negotiate=kerberos,wrapper \
--enable-external-acl-helpers=wbinfo_group,kerberos_ldap_group,LDAP_group,delayer,file_userip,SQL_session,unix_group \
--enable-cache-digests \
--enable-cachemgr-hostname=localhost \
--enable-delay-pools \
--enable-epoll \
--enable-icap-client \
--enable-ident-lookups \
--enable-linux-netfilter \
--enable-removal-policies=heap,lru \
--enable-snmp \
--enable-storeio=aufs,diskd,ufs,rock \
--enable-wccpv2 \
--enable-esi \
--enable-security-cert-generators \
--enable-security-cert-validators \
--with-aio \
--with-default-user=squid \
--with-filedescriptors=16384 \
--with-dl \
--with-openssl \
--enable-ssl-crtd \
--with-pthreads \
--with-included-ltdl \
--disable-arch-native \
--without-nettle

make && make install
ulimit -n 65536 
ulimit -a
useradd squid
chmod 777 /var/log/squid/
systemctl disable firewalld
cd /opt/youni_ipv4_to_ipv6

echo "=========== Creating Python Script ================="
cat <<EOF > /opt/youni_ipv4_to_ipv6/gen_squid_conf.py
import os
import random
import socket
import ipaddress  

def genIPv6(subnet, count):
    ipv6 = list()
    for _ in range(0, count):
        network = ipaddress.IPv6Network(subnet)
        address = ipaddress.IPv6Address(network.network_address + random.getrandbits(network.max_prefixlen - network.prefixlen))
        ipv6.append(address)
    return ipv6

def getIPv4():
    return socket.gethostbyname(socket.gethostname())

def getIPv6Subnet():
    # Generate a random IPv6 subnet
    return ipaddress.IPv6Network('2001:ee0:4f99:f350::/64')  # Example subnet. Replace it with your desired range.

def genSquidV4():
    ipv6_subnet = getIPv6Subnet()  # Automatically get IPv6 subnet
    external_ip = getIPv4()
    count = input('How many proxies do you need (ex: 1000) : ')
    start_port = 10000
    end_port = 90000

    config = ''' max_filedesc 5000000
access_log          none
cache_store_log     none
# Hide client ip #
forwarded_for delete
# Turn off via header #
via off
# Deny request for original source of a request
follow_x_forwarded_for allow localhost
follow_x_forwarded_for deny all
# See below
request_header_access X-Forwarded-For deny all
request_header_access Authorization allow all
request_header_access Proxy-Authorization allow all
request_header_access Cache-Control allow all
request_header_access Content-Length allow all
request_header_access Content-Type allow all
request_header_access Date allow all
request_header_access Host allow all
request_header_access If-Modified-Since allow all
request_header_access Pragma allow all
request_header_access Accept allow all
request_header_access Accept-Charset allow all
request_header_access Accept-Encoding allow all
request_header_access Accept-Language allow all
request_header_access Connection allow all
request_header_access All deny all
cache           deny    all
acl to_ipv6 dst ipv6
http_access deny all !to_ipv6
acl allow_net src 1.1.1.1
refresh_pattern ^ftp:       1440    20% 10080
refresh_pattern ^gopher:    1440    0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0 0%  0
refresh_pattern .       0   20% 4320
# Common settings
acl SSL_ports port 443
acl Safe_ports port 80      # http
acl Safe_ports port 21      # ftp
acl Safe_ports port 443     # https
acl Safe_ports port 70      # gopher
acl Safe_ports port 210     # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280     # http-mgmt
acl Safe_ports port 488     # gss-http
acl Safe_ports port 591     # filemaker
acl Safe_ports port 777     # multiling http
acl CONNECT method CONNECT
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
http_access allow localhost
http_access allow all'''

    bash_ipadd = ''
    proxy_list = ''
    ips = genIPv6(ipv6_subnet, int(count))

    for ip in ips:
        bash_ipadd = bash_ipadd + '\nip addr add '+ str(ip) + '/64 dev eth0'
        random_port = random.randint(start_port, end_port)
        config = config + '\n\n\nhttp_port ' + str(random_port) + '\nacl p' + str(random_port) + ' localport ' + str(random_port) + '\ntcp_outgoing_address ' + str(ip) + ' p' + str(random_port)
        proxy_list = proxy_list + '\n'+ str(external_ip) + ':' + str(random_port)

    config_file = open((os.path.dirname(os.path.abspath(__file__)))+'/squid_config.txt', 'w')
    config_file.write(config)
    config_file.close()

    bash_ipadd_file = open((os.path.dirname(os.path.abspath(__file__)))+'/squid_ipaddr.sh', 'w')
    bash_ipadd_file.write(bash_ipadd)
    bash_ipadd_file.close()

    external_ipfile = open((os.path.dirname(os.path.abspath(__file__)))+'/squid_proxy_list.txt', 'w')
    external_ipfile.write(proxy_list)
    external_ipfile.close()

if __name__ == "__main__":    
    genSquidV4()
EOF

python3 gen_squid_conf.py
