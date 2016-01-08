#!/bin/sh

case "$1" in
start)

echo - Initialisation :

# Vidage des tables et des regles personnelles
iptables -t filter -F
iptables -t filter -X
echo - Vidage des regles et des tables : [OK]

;;

parefeu)

echo - Initialisation du parefeu:

# Interdire toutes connexions entrantes et sortantes
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP
echo - Interdire toutes les connexions entrantes et sortantes : [OK]

# Ne pas casser les connexions etablies
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
echo - Ne pas casser les connexions établies : [OK]

########## Regles ##########

# Autoriser loopback
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT

# Autoriser le ping
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT

# Autoriser SSH
iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT

# Autoriser DNS
#iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
#iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT

# Autoriser NTP
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT

# Autoriser FTP
#modprobe ip_conntrack_ftp
#iptables -t filter -A OUTPUT -p tcp --dport 20:21 -j ACCEPT
#iptables -t filter -A INPUT -p tcp --dport 20:21 -j ACCEPT
#iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Autoriser HTTP et HTTPS
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
#iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
#iptables -t filter -A INPUT -p tcp --dport 8443 -j ACCEPT

# Autoriser POP3
#iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT

# Autoriser SMTP
#iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT

# Autoriser IMAP
#iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT

# Autoriser POP3S
#iptables -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT

# Autoriser DMA pour le Monitoring de la Dedibox
#iptables -A INPUT -i eth0 -s 88.191.254.0/24 -p tcp --dport 161 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A INPUT -i eth0 -s 88.191.254.0/24 -p udp --dport 161 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o eth0 -d 88.191.254.0/24 -p tcp --sport 161 -m state --state ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o eth0 -d 88.191.254.0/24 -p udp --sport 161 -m state --state ESTABLISHED -j ACCEPT
echo - Initialisation du parefeu : [OK]

;;

forward)

#forward the packets from your internal network, on /dev/eth1, to your external network on /dev/eth0
echo - Initialisation du forward 
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -i eth1 -o eth0 -j DROP
#http - https
iptables -A FORWARD -i eth1 -o eth0 -p tcp  --dport 80 -j  ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p tcp  --dport 80 -j  ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p tcp  --dport 443 -j  ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p tcp  --dport 443 -j  ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p tcp  --dport 8443 -j  ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p tcp  --dport 8443 -j  ACCEPT
#dns
iptables -A FORWARD -i eth1 -o eth0 -p tcp  --dport 53 -j  ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p tcp  --dport 53 -j  ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p udp  --dport 53 -j  ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p udp  --dport 53 -j  ACCEPT
#POP
iptables -A FORWARD -i eth1 -o eth0 -p tcp  --dport 110 -j  ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p tcp  --dport 110 -j  ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p tcp  --dport 995 -j  ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p tcp  --dport 995 -j  ACCEPT

#IMAP
iptables -A FORWARD -i eth1 -o eth0 -p tcp  --dport 143 -j  ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p tcp  --dport 143 -j  ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p tcp  --dport 993 -j  ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p tcp  --dport 993 -j  ACCEPT

#ping
#iptables -A FORWARD -i eth1 -o eth0 -p icmp -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j  ACCEPT
#iptables -A FORWARD -i eth1 -o eth0 -p icmp -m state --state NEW,ESTABLISHED,RELATED -j  ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p icmp -m state --state NEW,ESTABLISHED,RELATED -j  ACCEPT 
iptables -A FORWARD -i eth1 -o eth0 -p icmp --icmp-type echo-reply -m state --state NEW,ESTABLISHED,RELATED -j  ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p icmp --icmp-type echo-request -m state --state NEW,ESTABLISHED,RELATED -j  ACCEPT

#NTP
iptables -A FORWARD -i eth1 -o eth0 -p udp  --dport 123 -j  ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p udp  --dport 123 -j  ACCEPT


#DROP ALL
iptables -A FORWARD -i eth1 -o eth0 -j DROP

echo - Initialisation du forward : [OK]

;;

status)

echo - Liste des regles :
iptables -n -L

;;
stop)

# Vidage des tables et des regles personnelles
iptables -t filter -F
iptables -t filter -X
echo - Vidage des regles et des tables : [OK]

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
echo - Autoriser toutes les connexions entrantes et sortantes : [OK]

;;
esac
exit 0
