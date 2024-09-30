#!/bin/bash

# Iniciar la primera VPN
openvpn --config /etc/openvpn/vpn1.ovpn --daemon --socks-proxy 0.0.0.0 8080

# Iniciar la segunda VPN
openvpn --config /etc/openvpn/vpn2.ovpn --daemon --socks-proxy 0.0.0.0 8081

# Mantener el contenedor en ejecución
tail -f /dev/null