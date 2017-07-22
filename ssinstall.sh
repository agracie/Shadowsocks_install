#!/bin/bash

ip=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

read -s -p 'Enter Password: ' passwd

echo

read -s -p 'Enter Port: ' port

apt-get -y -o Acquire::ForceIPv4=true update  && apt-get -y install python-pip python-m2crypto  && easy_install shadowsocks

touch /etc/shadowsocks.json && sudo tee -a /etc/shadowsocks.json << EOL
{
"server":"$ip",
"server_port":$port,
"local_port":1080,
"password":"$passwd",
"timeout":600,
"method":"aes-256-cfb"
}
EOL

iptables -I INPUT -p tcp --dport $port -j ACCEPT

apt-get -y install iptables-persistent

ssserver -c /etc/shadowsocks.json -d start

systemctl enable shadowsocks
