#!/bin/bash

hostnamectl set-hostname archlinux

modprobe tcp_bbr

echo "tcp_bbr" > /etc/modules-load.d/80-bbr.conf

echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/80-bbr.conf

echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/80-bbr.conf

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/30-ipforward.conf

echo "net.core.rmem_default = 1048576" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.rmem_max = 16777216" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.wmem_default = 1048576" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.wmem_max = 16777216" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.optmem_max = 65536" >> /etc/sysctl.d/99-sysctl.conf

echo "net.ipv4.tcp_rmem = 4096 1048576 2097152" >> /etc/sysctl.d/99-sysctl.conf

echo "net.ipv4.tcp_wmem = 4096 65536 16777216" >> /etc/sysctl.d/99-sysctl.conf

echo "net.ipv4.udp_rmem_min = 8192" >> /etc/sysctl.d/99-sysctl.conf

echo "net.ipv4.udp_wmem_min = 8192" >> /etc/sysctl.d/99-sysctl.conf

echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.d/99-sysctl.conf

echo "net.core.netdev_max_backlog = 16384" >> /etc/sysctl.d/99-sysctl.conf

pacman -S --noconfirm docker

systemctl enable --now docker

mkdir temp && cd temp && mkdir accelerator

wget -O accelerator_docker https://raw.githubusercontent.com/thisdk/accelerator/main/accelerator

docker build -f accelerator_docker -t accelerator ./accelerator/

cd .. && rm -rf temp

docker network create --driver bridge jason

docker run --restart=always --network jason --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -d containrrr/watchtower:latest --cleanup

docker run --restart=always --network jason --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -d portainer/portainer-ce:latest

docker run --restart=always --network jason --name sing-box -p 80:80 -p 443:443 -p 443:443/udp -v /etc/sing-box:/etc/sing-box -d ghcr.io/sagernet/sing-box:latest run -c /etc/sing-box/config.json

docker run --restart=always --network host --name accelerator -e UDP2RAW_PORT=8383 -e KCPTUN_DS=4 -e KCPTUN_PS=4 -d accelerator:latest
