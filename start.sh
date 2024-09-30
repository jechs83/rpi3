#!/bin/bash

# Iniciar la primera VPN
openvpn --config /etc/openvpn/vpn1.ovpn --daemon --socks-proxy 127.0.0.1 1080

# Iniciar la segunda VPN
openvpn --config /etc/openvpn/vpn2.ovpn --daemon --socks-proxy 127.0.0.1 1081

# Mantener el contenedor en ejecución
tail -f /dev/null