#!/bin/bash

hostnamectl set-hostname archlinux

modprobe tcp_bbr

echo "tcp_bbr" > /etc/modules-load.d/80-bbr.conf

echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/80-bbr.conf

echo "net.core.default_qdisc=fq_codel" >> /etc/sysctl.d/80-bbr.conf

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

