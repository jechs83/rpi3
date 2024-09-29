FROM arm64v8/debian:latest

# Actualizamos e instalamos las herramientas necesarias: Squid, OpenVPN, etc.
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

# Crear un script para iniciar OpenVPN y Squid
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Copiar los archivos de configuración necesarios
ARG CONFIG_FILE
COPY ${CONFIG_FILE} /etc/squid/squid.conf
ARG OVPN_FILE
COPY ${OVPN_FILE} /etc/openvpn/client.ovpn

# Definir el puerto de Squid como una variable de entorno
ENV SQUID_PORT=3128

# Exponer el puerto para Squid
EXPOSE ${SQUID_PORT}

# Iniciar OpenVPN y Squid cuando se inicie el contenedor
CMD ["/usr/local/bin/start.sh"]