FROM arm64v8/debian:latest

# Update and install necessary tools
RUN apt-get update && apt-get install -y \
    squid \
    openvpn \
    procps \
    net-tools \
    iptables \
    curl \
    dnsutils \
    nano \
    iputils-ping \
    iproute2 \
    && apt-get clean

# Use build argument for OpenVPN config
ARG OPENVPN_CONFIG=client.ovpn
# Copy the OpenVPN config file
COPY ${OPENVPN_CONFIG} /etc/openvpn/client.conf

# Copy Squid configuration
COPY squid.conf /etc/squid/squid.conf

# Copy and set permissions for start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Define Squid port as an environment variable
ENV SQUID_PORT=3128

# Expose the dynamic Squid port
EXPOSE ${SQUID_PORT}

# Start OpenVPN and Squid when the container starts
CMD ["/usr/local/bin/start.sh"]