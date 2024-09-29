#!/bin/bash

# Start OpenVPN using client.conf
openvpn --config /etc/openvpn/client.conf &

# Configure Squid's dynamic port
sed -i "s/\${SQUID_PORT}/${SQUID_PORT}/" /etc/squid/squid.conf

# Start Squid
service squid start

# Keep the container running
tail -f /dev/null