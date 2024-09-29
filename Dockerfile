# Etapa 1: Base de la imagen
FROM arm64v8/debian:latest

# Instalar las librerías necesarias
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

# Copiar archivos externos de configuración
COPY client.ovpn /etc/openvpn/client.conf
COPY squid.conf /etc/squid/squid.conf

# Crear un directorio de logs para squid
RUN mkdir -p /var/log/squid && touch /var/log/squid/access.log

# Exponer el puerto para el proxy Squid
EXPOSE 3128

# Comando de inicio
CMD openvpn --config /etc/openvpn/client.conf & squid -N -f /etc/squid/squid.conf