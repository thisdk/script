#!/bin/bash

hostnamectl set-hostname arch

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

pacman -S --noconfirm base-devel docker && systemctl enable --now docker

docker network create --driver bridge --ipv6 --subnet fd88::/80 jason

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -d ghcr.io/containrrr/watchtower:latest --cleanup -s "0 0 5 * * *"

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -d portainer/portainer-ce:latest

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name vaultwarden -p 3012:3012 -v vaultwarden_data:/data -e SIGNUPS_ALLOWED=false -e INVITATIONS_ALLOWED=false -e WEBSOCKET_ENABLED=true -e ADMIN_TOKEN='$argon2id$v=19$m=65540,t=3,p=4$Wv/oKINnp3hEzzP2ic+3DNTxapoQhPiAQXS5hJmzFac$/DrKy4XoYl0QG2Z50Lfe/fIAuoZOlLOBWMmuYxIR5aM' -d ghcr.io/dani-garcia/vaultwarden:alpine

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name sing-box -p 80:80 -p 443:443/udp -v /etc/sing-box:/etc/sing-box -d ghcr.io/sagernet/sing-box:latest -D /var/lib/sing-box -C /etc/sing-box/ run

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name nginx -p 443:443/tcp -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf -d nginx:alpine

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name wireguard --cap-add=NET_ADMIN --cap-add=SYS_MODULE -v /etc/wireguard/config:/config -v /lib/modules:/lib/modules -e PUID=1000 -e PGID=1000 -e SERVERPORT=51820 -e PEERS=1 -e PEERDNS=auto -e INTERNAL_SUBNET=10.18.88.0 -e PERSISTENTKEEPALIVE_PEERS=25 -e LOG_CONFS=true -d ghcr.io/linuxserver/wireguard:latest

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8585:8585 -e TCN=wireguard -e TCP=51820 -e FEC=1:1,2:2,8:6,20:10 --cap-add NET_ADMIN -d ghcr.io/thisdk/accelerator:latest


