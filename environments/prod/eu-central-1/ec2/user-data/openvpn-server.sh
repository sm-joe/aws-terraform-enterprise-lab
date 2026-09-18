#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

VPN_CLIENT_CIDR="10.100.0.0"
VPN_CLIENT_NETMASK="255.255.255.0"
VPN_VPC_CIDR="10.30.0.0/22"
VPN_SERVER_PORT="1194"

apt-get update
apt-get install -y \
  openvpn \
  easy-rsa \
  ca-certificates \
  curl

mkdir -p /etc/openvpn/server
mkdir -p /etc/openvpn/easy-rsa

cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/

cd /etc/openvpn/easy-rsa

./easyrsa init-pki

EASYRSA_BATCH=1 ./easyrsa build-ca nopass

EASYRSA_BATCH=1 ./easyrsa gen-req server nopass

EASYRSA_BATCH=1 ./easyrsa sign-req server server

./easyrsa gen-dh

openvpn --genkey secret /etc/openvpn/server/ta.key

cp pki/ca.crt /etc/openvpn/server/
cp pki/issued/server.crt /etc/openvpn/server/
cp pki/private/server.key /etc/openvpn/server/
cp pki/dh.pem /etc/openvpn/server/

chmod 600 /etc/openvpn/server/server.key
chmod 600 /etc/openvpn/server/ta.key

cat > /etc/openvpn/server/server.conf <<EOF
port ${VPN_SERVER_PORT}
proto udp
dev tun

user nobody
group nogroup

persist-key
persist-tun

topology subnet

server ${VPN_CLIENT_CIDR} ${VPN_CLIENT_NETMASK}

push "route ${VPN_VPC_CIDR}"
push "redirect-gateway def1 bypass-dhcp"

keepalive 10 120

ca /etc/openvpn/server/ca.crt
cert /etc/openvpn/server/server.crt
key /etc/openvpn/server/server.key
dh /etc/openvpn/server/dh.pem

tls-crypt /etc/openvpn/server/ta.key

tls-version-min 1.2

data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305

auth SHA256

user nobody
group nogroup

status /var/log/openvpn-status.log
log-append /var/log/openvpn.log

verb 3

explicit-exit-notify 1
EOF

cat > /etc/sysctl.d/50-openvpn-forwarding.conf <<EOF
net.ipv4.ip_forward = 1
EOF

sysctl --system

apt-get install -y iptables-persistent

PUBLIC_INTERFACE="$(ip route get 1.1.1.1 | awk '{print $5; exit}')"

iptables -t nat -A POSTROUTING \
  -s 10.100.0.0/24 \
  -o "${PUBLIC_INTERFACE}" \
  -j MASQUERADE

iptables -A FORWARD \
  -s 10.100.0.0/24 \
  -o "${PUBLIC_INTERFACE}" \
  -j ACCEPT

iptables -A FORWARD \
  -d 10.100.0.0/24 \
  -i "${PUBLIC_INTERFACE}" \
  -m conntrack \
  --ctstate ESTABLISHED,RELATED \
  -j ACCEPT

netfilter-persistent save

systemctl daemon-reload
systemctl enable openvpn-server@server
systemctl start openvpn-server@server

systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
