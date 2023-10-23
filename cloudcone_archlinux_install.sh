#!/bin/bash

hostnamectl set-hostname archlinux

modprobe tcp_bbr

echo "tcp_bbr" > /etc/modules-load.d/80-bbr.conf

echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/80-bbr.conf

echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/80-bbr.conf

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/30-ipforward.conf

echo "net.ipv6.conf.default.forwarding=1" >> /etc/sysctl.d/30-ipforward.conf

echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/30-ipforward.conf

mkdir /etc/docker

wget https://raw.githubusercontent.com/thisdk/script/main/daemon.json -O /etc/docker/daemon.json

pacman -Syyu --noconfirm

pacman -S --noconfirm base-devel docker

systemctl enable --now docker

mkdir temp && cd temp && mkdir accelerator

wget -O accelerator_docker https://raw.githubusercontent.com/thisdk/accelerator/main/accelerator

docker build -f accelerator_docker -t accelerator ./accelerator/

cd .. && rm -rf temp

docker network create --driver bridge --ipv6 --subnet fd99::/80 jason

docker run --restart=always --network jason --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -d containrrr/watchtower:latest --cleanup

docker run --restart=always --network jason --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -d portainer/portainer-ce:latest

docker run --restart=always --network jason --name docker.2048 -d alexwhen/docker-2048:latest

docker run --restart=always --network jason --name sing-box -p 80:80 -v /etc/sing-box:/etc/sing-box -d ghcr.io/sagernet/sing-box:latest run -c /etc/sing-box/config.json

docker run --restart=always --network jason --name nginx -p 443:443 -p 443:443/udp -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf -d nginx:latest

docker run --restart=always --network jason --name accelerator-v4 -p 8585:8585 --cap-add NET_ADMIN -e UDP2RAW_PORT=8585 -d accelerator

docker run --restart=always --network jason --name accelerator-v6 -p 8686:8686 --cap-add NET_ADMIN -e UDP2RAW_ADDRESS=[::] -e UDP2RAW_PORT=8686 -d accelerator
