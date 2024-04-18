# Trình cài đặt proxy mực dễ dàng

https://xpresservers.com

Tự động cài đặt proxy Squid 3 trên hệ điều hành linux sau.

* Ubuntu 14.04, 16.04, 18.04, 20.04, 22.04
* Debian 8, 9, 10, 11, 12
* CentOS 7, 8
* CentOS Steam 8, 9
* AlmaLinux 8, 9


## Cài đặt Squid

Để cài đặt, hãy chạy tập lệnh

```
wget https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid3-install.sh -O Squid3-install.sh
sudo bash ink3-install.sh
```

# Tạo người dùng proxy

Để tạo người dùng, hãy chạy

```
người dùng mực-add
```

HOẶC chạy các lệnh sau

```
sudo /usr/bin/htpasswd -b -c /etc/squid/passwd USERNAME_HERE PASSWORD_HERE
```

Để cập nhật mật khẩu cho người dùng hiện tại, hãy chạy

```
sudo /usr/bin/htpasswd /etc/squid/passwd USERNAME_HERE
```

thay thế USERNAME_HERE và PASSWORD_HERE bằng tên người dùng và mật khẩu bạn muốn.

Tải lại proxy mực

```
sudo systemctl tải lại mực
```

# Cấu hình nhiều địa chỉ IP

LƯU Ý: Điều này chỉ cần thiết nếu bạn có nhiều IP trên máy chủ của mình.

Trước khi có thể định cấu hình mực để sử dụng nhiều địa chỉ IP, bạn cần thêm IP vào máy chủ của mình và bạn sẽ có thể kết nối với máy chủ bằng các IP này.

Sau khi thêm IP vào máy chủ của bạn, bạn có thể định cấu hình nó để sử dụng với proxy mực bằng cách chạy lệnh sau

```
wget https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid-conf-ip.sh
sudo bash mực-conf-ip.sh
```

# Thay đổi cổng Proxy Squid

Cổng proxy mực mặc định là 3128. Bài đăng trên blog này sẽ hướng dẫn cách thay đổi cổng mực.

LÀM

# Ủng hộ

Nếu bạn cần sự trợ giúp chuyên nghiệp, hãy liên hệ với

https://xpresservers.com/contact