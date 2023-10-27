#!/bin/bash

hostnamectl set-hostname archlinux

modprobe tcp_bbr

echo "tcp_bbr" > /etc/modules-load.d/80-bbr.conf

echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/80-bbr.conf

echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/80-bbr.conf

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/30-ipforward.conf

echo "net.ipv6.conf.default.forwarding=1" >> /etc/sysctl.d/30-ipforward.conf

echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/30-ipforward.conf

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

mkdir /etc/docker

wget https://raw.githubusercontent.com/thisdk/script/main/daemon.json -O /etc/docker/daemon.json

pacman -Syyu --noconfirm

pacman -S --noconfirm base-devel docker

systemctl enable --now docker

mkdir temp && cd temp && mkdir accelerator

wget -O accelerator_docker https://raw.githubusercontent.com/thisdk/accelerator/main/accelerator

docker build -f accelerator_docker -t accelerator ./accelerator/

cd .. && rm -rf temp

ping -4 -c 2 hysteria2.thisdk.tk && ping -6 -c 2 hysteria2.thisdk.tk

ping -4 -c 2 www.thisdk.tk && ping -6 -c 2 www.thisdk.tk

ping -4 -c 2 qbit.thisdk.tk && ping -6 -c 2 qbit.thisdk.tk

ping -4 -c 2 2048.thisdk.tk && ping -6 -c 2 2048.thisdk.tk

ping -4 -c 2 alist.thisdk.tk && ping -6 -c 2 alist.thisdk.tk

ping -4 -c 2 docker.thisdk.tk && ping -6 -c 2 docker.thisdk.tk

docker network create --driver bridge --ipv6 --subnet fd99::/80 jason

docker run --restart=always --network jason --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -d containrrr/watchtower:latest --cleanup

docker run --restart=always --network jason --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -d portainer/portainer-ce:latest

docker run --restart=always --network jason --name docker.2048 -d alexwhen/docker-2048:latest

docker run --restart=always --network jason --name sing-box -p 80:80 -p 443:443/udp -v /etc/sing-box:/etc/sing-box -d ghcr.io/sagernet/sing-box:latest run -c /etc/sing-box/config.json

docker run --restart=always --network jason --name nginx -p 443:443 -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf -d nginx:latest

docker run --restart=always --network jason --name accelerator-v4 -p 8585:8585 --cap-add NET_ADMIN -e UDP2RAW_PORT=8585 -d accelerator

docker run --restart=always --network jason --name accelerator-v6 -p 8686:8686 --cap-add NET_ADMIN -e UDP2RAW_ADDRESS=[::] -e UDP2RAW_PORT=8686 -d accelerator

docker run --restart=always --network jason --name alist -v /etc/alist:/opt/alist/data -e PUID=0 -e PGID=0 -e UMASK=022 -d xhofe/alist:latest

docker run --restart=always --network jason --name qbittorrent -p 6881:6881 -p 6881:6881/udp -e PUID=0 -e PGID=0 -e UMASK=022 --volumes-from alist -d hotio/qbittorrent:latest
