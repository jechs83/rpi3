FROM arm64v8/debian:latest

# Actualizamos e instalamos las herramientas necesarias
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

# Copiamos el archivo de configuración de Squid y scripts de inicio
COPY squid.conf /etc/squid/squid.conf
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Definimos el puerto de Squid como una variable de entorno
ENV SQUID_PORT=3128

# Exponemos el puerto para Squid
EXPOSE ${SQUID_PORT}

# Ejecutamos el script de inicio al arrancar el contenedor
CMD ["/usr/local/bin/start.sh"]