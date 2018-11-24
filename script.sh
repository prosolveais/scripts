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

# 2: allow dns connection
iptables -A OUTPUT -p UDP --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p UDP --dport 53 -j ACCEPT

# 3: allow ntp connection
iptables -A OUTPUT -p UDP --dport 123 -j ACCEPT
ip6tables -A OUTPUT -p UDP --dport 123 -j ACCEPT

# 4: allow connection the have been made by this pc
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 5: allow connection to prosolve.ml & prosolve2018.ml
iptables -A OUTPUT -p tcp -d prosolve.ml -m multiport --dport 80,443 -j ACCEPT
ip6tables -A OUTPUT -p tcp -d prosolve.ml -m multiport --dport 80,443 -j ACCEPT
iptables -A OUTPUT -p tcp -d prosolve2018.ml -m multiport --dport 80,443 -j ACCEPT
ip6tables -A OUTPUT -p tcp -d prosolve2018.ml -m multiport --dport 80,443 -j ACCEPT

# 6: reject everything
iptables -A INPUT -j REJECT
ip6tables -A INPUT -j REJECT
iptables -A OUTPUT -j REJECT
ip6tables -A OUTPUT -j REJECT
