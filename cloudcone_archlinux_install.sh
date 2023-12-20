#!/bin/bash

hostnamectl set-hostname archlinux

modprobe tcp_bbr

echo "tcp_bbr" > /etc/modules-load.d/80-bbr.conf

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/30-ipforward.conf

echo "net.ipv6.conf.default.forwarding=1" >> /etc/sysctl.d/30-ipforward.conf

echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/30-ipforward.conf

echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/80-bbr.conf

echo "net.core.default_qdisc=cake" >> /etc/sysctl.d/80-bbr.conf

echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.d/99-sysctl.conf

echo "net.ipv4.tcp_rmem = 4096 1048576 4194304" >> /etc/sysctl.d/99-sysctl.conf

echo "net.ipv4.tcp_wmem = 4096 65536 33554432" >> /etc/sysctl.d/99-sysctl.conf

echo "net.ipv4.udp_rmem_min = 8192" >> /etc/sysctl.d/99-sysctl.conf

echo "net.ipv4.udp_wmem_min = 8192" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.somaxconn = 8192" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.rmem_default = 2097152" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.rmem_max = 33554432" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.wmem_default = 2097152" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.wmem_max = 33554432" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.optmem_max = 65536" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.netdev_max_backlog = 16384" >> /etc/sysctl.d/99-sysctl.conf

timedatectl set-ntp true && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && hwclock --systohc

mkdir /etc/docker && wget https://raw.githubusercontent.com/thisdk/script/main/daemon.json -O /etc/docker/daemon.json

openssl ecparam -genkey -name prime256v1 -out /etc/sing-box/cert/www.berkeley.edu.key

openssl req -new -x509 -days 365 -key /etc/sing-box/cert/www.berkeley.edu.key -out /etc/sing-box/cert/www.berkeley.edu.pem -subj "/C=US/ST=California/L=Berkeley/O=University of California/OU=www/CN=www.berkeley.edu"

openssl ecparam -genkey -name prime256v1 -out /etc/sing-box/cert/docker.thisdk.io.key

openssl req -new -x509 -days 365 -key /etc/sing-box/cert/docker.thisdk.io.key -out /etc/sing-box/cert/docker.thisdk.io.pem -subj "/C=US/ST=California/OU=docker/CN=docker.thisdk.io"

pacman -S --noconfirm base-devel docker unzip && systemctl enable --now docker

docker network create --driver bridge --ipv6 --subnet fd86::/80 jason

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -d containrrr/watchtower:latest --cleanup --interval 21600

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -d portainer/portainer-ce:latest

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name sing-box -p 443:443/udp -v /etc/sing-box:/etc/sing-box -d ghcr.io/sagernet/sing-box:latest run -c /etc/sing-box/config.json

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name nginx -p 443:443/tcp -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf -d nginx:alpine

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name=wireguard --cap-add=NET_ADMIN --cap-add=SYS_MODULE -e PUID=1000 -e PGID=1000 -e SERVERURL=148.135.96.144 -e SERVERPORT=51820 -e PEERS=1 -e PEERDNS=auto -e INTERNAL_SUBNET=10.18.88.0 -e PERSISTENTKEEPALIVE_PEERS=25 -e LOG_CONFS=true -v /etc/wireguard/config:/config -v /lib/modules:/lib/modules -d lscr.io/linuxserver/wireguard:latest
 
docker run --restart=always --network jason -e TZ=Asia/Shanghai --name=kcptube -p 58535-58585:58535-58585/udp -v /etc/kcptube:/etc/kcptube -d ghcr.io/thisdk/kcptube:latest /etc/kcptube/config.conf
