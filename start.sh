#!/bin/bash

# Inicia OpenVPN
openvpn --config /etc/openvpn/client/client1.ovpn --daemon

# Espera a que la conexión VPN se establezca
sleep 10

# Inicia Squid en el puerto 3128 con la configuración squid1.conf
squid -f /etc/squid/squid1.conf

# Inicia Squid en el puerto 3129 con la configuración squid2.conf
squid -f /etc/squid/squid2.conf -N

# Mantén el contenedor en ejecución
tail -f /dev/null