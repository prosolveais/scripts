#######################################
### PROSOLVE iptables configuration ###
#######################################

# 0: drop all policy
iptables -F
ip6tables -F

# 1: allow loopback connection
iptables -I INPUT 1 -i lo -j ACCEPT
ip6tables -I INPUT 1 -i lo -j ACCEPT
iptables -I OUTPUT 1 -o lo -j ACCEPT
ip6tables -I OUTPUT 1 -o lo -j ACCEPT

# 3: allow dns connection
iptables -A OUTPUT -p UDP --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p UDP --dport 53 -j ACCEPT

# 2: allow connection the have been made by this pc
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 4: allow connection to prosolve.ml
iptables -A OUTPUT -p tcp -d prosolve.ml -m multiport --dport 80,443 -j ACCEPT
ip6tables -A OUTPUT -p tcp -d prosolve.ml -m multiport --dport 80,443 -j ACCEPT

# 5: drop everything
iptables -P INPUT DROP
ip6tables -P INPUT DROP
iptables -P FORWARD DROP
ip6tables -P FORWARD DROP
iptables -P OUTPUT DROP
ip6tables -P OUTPUT DROP
