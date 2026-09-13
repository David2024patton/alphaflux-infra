#!/bin/sh
# Route replies to Cradlepoint-delivered traffic back out enp4s0 (107.90.116.157)
# so inbound DMZ sessions complete; bulk egress stays on the fiber default route.
ip rule replace from 192.168.10.10 table 100
ip rule replace fwmark 0x1 table 100
ip route replace default via 192.168.10.1 dev enp4s0 table 100
ip route replace 172.17.0.0/16 dev docker0 table 100
ip route replace 172.18.0.0/16 dev docker_gwbridge table 100
ip route replace 172.20.0.0/16 dev br-ef8be8ccf7b5 table 100
ip route replace 192.168.0.0/24 dev enp5s0 table 100
sysctl -w net.ipv4.conf.all.rp_filter=0 >/dev/null
sysctl -w net.ipv4.conf.enp4s0.rp_filter=0 >/dev/null
iptables -t mangle -C PREROUTING -i enp4s0 -j CONNMARK --set-xmark 0x1 2>/dev/null || iptables -t mangle -A PREROUTING -i enp4s0 -j CONNMARK --set-xmark 0x1
iptables -t mangle -C PREROUTING -j CONNMARK --restore-mark 2>/dev/null || iptables -t mangle -A PREROUTING -j CONNMARK --restore-mark
iptables -t mangle -C OUTPUT -j CONNMARK --restore-mark 2>/dev/null || iptables -t mangle -A OUTPUT -j CONNMARK --restore-mark
