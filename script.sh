#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

# clear existing iptables
iptables -X
iptables -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# for loopback device
iptables -I INPUT 1 -i lo -j ACCEPT

# prosolve server
printf "147.75.94.253\tprosolve.ml\n" >> /etc/hosts
iptables -A INPUT -s 147.75.94.253 -j ACCEPT
iptables -A OUTPUT -d 147.75.94.253 -j ACCEPT

# for systemd-resolved's stub resolver
iptables -A INPUT -s 127.0.0.53 -j ACCEPT
iptables -A OUTPUT -d 127.0.0.53 -j ACCEPT

# drop all other connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -P INPUT DROP
iptables -P OUTPUT DROP

# final step
systemctl restart systemd-resolved
