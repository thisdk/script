#!/bin/bash

hostnamectl set-hostname archlinux

modprobe tcp_bbr

echo "tcp_bbr" > /etc/modules-load.d/80-bbr.conf

echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/80-bbr.conf

echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/80-bbr.conf

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/30-ipforward.conf

mkdir /etc/sing-box

pacman -S --noconfirm docker

systemctl enable --now docker

mkdir temp && cd temp && mkdir accelerator

wget -O accelerator_docker https://raw.githubusercontent.com/thisdk/accelerator/main/accelerator

docker build -f accelerator_docker -t accelerator ./accelerator/

cd .. && rm -rf temp

docker network create --driver bridge jason

docker run --restart=always --network jason --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -d containrrr/watchtower:latest --cleanup

docker run --restart=always --network jason --name sing-box -p 80:80 -p 443:443 -p 443:443/udp -v /etc/sing-box:/etc/sing-box -d ghcr.io/sagernet/sing-box:latest run -c /etc/sing-box/config.json

docker run --restart=always --network jason --name accelerator -p 8585:8585 --cap-add NET_ADMIN -e UDP2RAW_PORT=8585 -e KCPTUN_PS=2 -d accelerator
