#!/bin/bash

# Make a backup copy of the original FTP configuration file
/usr/bin/sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig

# Modify the FTP configuration file to disable anonymous access
/usr/bin/sudo sed -i 's/#anonymous_enable=NO/g' /etc/vsftpd.conf
/usr/bin/sudo sed -i 's/xferlog_std_format=NO/g' /etc/vsftpd.conf
/usr/bin/sudo sed -i -a 's/local_root=/ftp 
userlist_file=/etc/vsftpd/user_list
userlist_deny=NO
vsftpd_log_file=/var/log/vsftpd.log
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
ssl_ciphers=ALL:-ADH:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP
rsa_cert_file=/etc/vsftpd/vsftpd.pem/g' /etc/vsftpd.conf

# Generate a self-signed SSL/TLS certificate for use with FTP
/usr/bin/sudo openssl req -x509 -nodes -newkey rsa:1024 -keyout /etc/vsftpd/vsftpd.pem -out /etc/vsftpd/vsftpd.pem

# Open firewall ports for FTP traffic and SSL/TLS
/usr/bin/sudo ufw allow ftp
/usr/bin/sudo ufw allow 20/tcp
/usr/bin/sudo ufw allow 21/tcp


# Restart the FTP server to apply the new configuration changes
/usr/bin/sudo systemctl restart vsftpd.service
