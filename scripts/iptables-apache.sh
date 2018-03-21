#!/bin/bash/
#con este script creamos una serie de reglas iptables para un cortafuegos.
#añadir el .sh al final del fichero sin no no funcinara.
#primero borramos las reglas iptables ya establecidas
sudo iptables -F
sudo iptables -t nat -F
#establecemos las politicas del cortafuegos.
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -P PREROUTING ACCEPT
sudo iptables -t nat -P POSTROUTING ACCEPT
#empezamos a filtrar:
sudo echo "filtrando"
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -s 172.16.12.1/24 -o enp0s8 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -s 172.16.20.1/24 -o enp0s9 -j MASQUERADE
#aceptar el puerto 80 (http).
#probar cambiando INPUT por FORWARD
sudo iptables -I FORWARD -s 172.16.10.3/24 -i enp0s8 -p tcp --dport 80 -j ACCEPT
sudo iptables -I FORWARD -s 172.16.10.3/14 -i enp0s9 -p tcp --dport 80 -j ACCEPT
#estas reglas definen que todas las solicitudes que vayan tanto al servidor Apache directo e inverso(Proxy)
#vaya por el puerto 80 por las interfaces enp0s8 i enp0s9(Ubuntu)
sudo iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j DNAT --to-destination 172.16.12.2:80
sudo iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 80 -j DNAT --to-destination 172.16.12.2:80
sudo iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j DNAT --to-destination 172.16.10.3:80
sudo iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 80 -j DNAT --to-destination 172.16.10.3:80
#redireccionar del servidor apache al proxy inverso(Apache)
sudo iptables -t nat -A PREROUTING -p tcp -s 172.16.12.2/24 --dport 80  -j DNAT --to-destination 172.16.10.3:80
#iniciar el enrutamiento:
echo "1" | sudo tee -a /proc/sys/net/ipv4/ip_forward

