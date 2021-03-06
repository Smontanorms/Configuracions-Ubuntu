#!/bin/bash/
#añadir el .sh al final del fichero sin no no funcinara.
#reglas pra las iptables del squid proxy:
#borrar las normas ya establecidas:
sudo iptables -F
sudo iptables -X
sudo iptables -Z
sudo iptables -t nat -F
#establecer las politicas del cortafuegos:
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -p nat -P PEROUTING ACCEPT
sudo iptables -p nat -P POSTROUTING ACCEPT
#enmascaramiento de la red:
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -s 172.16.22.8
#aceptar el puerto 8080:squid
iptables -A FORWARD -s 172.16.22.8/24 -i enp0s9 -p tcp --dport 8080 -j ACCEPT
#redireccionamiento al servidor squid proxy:
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 172.16.20.5:8080
iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 8080 -j DNAT --to-destination 172.16.20.5:8080
iptables -t nat -A PREROUTING -p tcp -s 172.16.22.11/24 --dport 8080 -j DNAT --to-destination 172.16.20.5:8080

