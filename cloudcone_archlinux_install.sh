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

pacman -S --noconfirm base-devel docker unzip

systemctl enable --now docker

ping -c 2 www.thisdk.tk

ping -c 2 qbit.thisdk.tk

ping -c 2 alist.thisdk.tk

ping -c 2 tools.thisdk.tk

ping -c 2 docker.thisdk.tk

ping -c 2 hysteria2.thisdk.tk

docker network create --driver bridge --ipv6 --subnet fd86::/80 jason

docker run --restart=always --network jason --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -d containrrr/watchtower:latest --cleanup

docker run --restart=always --network jason --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -d portainer/portainer-ce:latest

docker run --restart=always --network jason --name tools -d ghcr.io/corentinth/it-tools:latest

docker run --restart=always --network jason --name alist -v /etc/alist:/opt/alist/data -e PUID=0 -e PGID=0 -e UMASK=022 -d xhofe/alist-aria2:latest

docker run --restart=always --network jason --name qbittorrent -p 6881:6881 -p 6881:6881/udp -v /etc/qbittorrent:/config --volumes-from alist -e PUID=0 -e PGID=0 -e UMASK=022 -d qbittorrentofficial/qbittorrent-nox:latest

docker run --restart=always --network jason --name sing-box -p 80:80 -p 443:443/udp -v /etc/sing-box:/etc/sing-box -d ghcr.io/sagernet/sing-box:latest run -c /etc/sing-box/config.json

docker run --restart=always --network jason --name nginx -p 443:443 -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf -d nginx:latest
