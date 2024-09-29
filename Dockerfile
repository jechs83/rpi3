FROM arm64v8/debian:latest

# Actualizamos e instalamos las herramientas necesarias: Squid, OpenVPN, procps, net-tools, iptables, curl, dnsutils, nano, iputils-ping
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

# Copiar el archivo de configuración de Squid y modificar el puerto
COPY squid.conf /tmp/squid.conf
RUN sed -i "s/^http_port .*/http_port ${SQUID_PORT}/" /tmp/squid.conf && \
    mv /tmp/squid.conf /etc/squid/squid.conf

# Copiar el archivo de configuración de OpenVPN desde el directorio del Dockerfile y renombrarlo a client.conf
COPY client.ovpn /etc/openvpn/client.conf

# Copiar el script de inicio
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Definir el puerto de Squid como una variable de entorno
ENV SQUID_PORT=3128
ENV OPENVPN_CONFIG=/etc/openvpn/client.conf

# Exponer el puerto dinámico para Squid
EXPOSE ${SQUID_PORT}

# Iniciar OpenVPN y Squid cuando se inicie el contenedor
CMD ["/usr/local/bin/start.sh"]