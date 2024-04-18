# Trình cài đặt proxy mực dễ dàng


Tự động cài đặt proxy Squid 3 trên hệ điều hành linux sau.

* Ubuntu
* Debian 
* CentOS 
* CentOS Steam
* AlmaLinux 


## Cài đặt Squid

Để cài đặt, hãy chạy tập lệnh:

wget https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid3-install.sh

chmod 777 squid3-install.sh

sudo ./squid3-install.sh

# Tạo người dùng proxy

sudo /usr/bin/htpasswd -b -c /etc/squid/passwd USERNAME_HERE PASSWORD_HERE

Để cập nhật mật khẩu cho người dùng hiện tại, hãy conf

sudo /usr/bin/htpasswd /etc/squid/passwd USERNAME_HERE

thay thế USERNAME_HERE và PASSWORD_HERE bằng tên người dùng và mật khẩu bạn muốn.

Tải lại proxy conf

sudo systemctl tải lại 


# Cấu hình nhiều địa chỉ IP

LƯU Ý: Điều này chỉ cần thiết nếu bạn có nhiều IP trên máy chủ của mình.

Trước khi có thể định cấu hình mực để sử dụng nhiều địa chỉ IP, bạn cần thêm IP vào máy chủ của mình và bạn sẽ có thể kết nối với máy chủ bằng các IP này.

Sau khi thêm IP vào máy chủ của bạn, bạn có thể định cấu hình nó để sử dụng với proxy mực bằng cách chạy lệnh sau: 
wget https://raw.githubusercontent.com/fviatool/squid-proxy/main/squid-conf-ip.sh
sudo bash squid-conf-ip.sh


# Thay đổi cổng Proxy Squid

Cổng proxy mực mặc định là 3128. Bài đăng trên blog này sẽ hướng dẫn cách thay đổi cổng mực.
