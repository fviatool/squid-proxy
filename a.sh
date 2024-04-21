#!/bin/bash

echo "=========== Install Required Packages ================="
yum -y groupinstall 'Development Tools'
yum install -y perl gcc autoconf automake make sudo wget libxml2-devel libcap-devel libtool-ltdl-devel install gcc-c++
yum -y python pip
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
ulimit -n 65536 ulimit -a
useradd squid
chmod 777 /var/log/squid/
systemctl disable firewalld
cd /opt/youni_ipv4_to_ipv6

echo "=========== Creating Python Script ================="
cat <<EOF > gen_squid_conf.sh
#!/bin/bash

genIPv6() {
    subnet=\$1
    count=\$2
    ipv6=()
    for ((i=0; i<count; i++)); do
        address=\$(python3 -c "import random; import ipaddress; network = ipaddress.IPv6Network('\$subnet'); print(network.network_address + random.getrandbits(network.max_prefixlen - network.prefixlen))")
        ipv6+=("\$address")
    done
    echo "\${ipv6[@]}"
}

getIPv4() {
    hostname -I | awk '{print \$1}'
}

getIPv6Subnet() {
    echo "2001:ee0:4f99:f350::/64"
}

genSquidV4() {
    ipv6_subnet=\$(getIPv6Subnet)
    external_ip=\$(getIPv4)
    read -p "How many proxies do you need (ex: 1000) : " count
    start_port=10000
    end_port=90000

    config=''' max_filedesc 5000000
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

    bash_ipadd=''
    proxy_list=''
    ips=("\$(genIPv6 \$ipv6_subnet \$count)")

    for ip in "\${ips[@]}"; do
        bash_ipadd+="\nip addr add \$ip/64 dev eth0"
        random_port=\$((RANDOM % (\$end_port - \$start_port + 1) + \$start_port))
        config+="\n\n\nhttp_port \$random_port\nacl p\$random_port localport \$random_port\ntcp_outgoing_address \$ip p\$random_port"
        proxy_list+="\n\$external_ip:\$random_port"
    done

    echo "\$config" > squid_config.txt
    echo "\$bash_ipadd" > squid_ipaddr.sh
    echo "\$proxy_list" > squid_proxy_list.txt
}

genSquidV4
EOF

chmod +x gen_squid_conf.sh
./gen_squid_conf.sh
