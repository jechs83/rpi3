#!/bin/bash

# Iniciar OpenVPN
openvpn --config /etc/openvpn/client.ovpn &

# Iniciar Squid
squid -N -f /etc/squid/squid.conf