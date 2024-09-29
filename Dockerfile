# Usa una imagen base de Raspberry Pi
FROM arm32v7/debian:buster-slim

# Instala las dependencias necesarias
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

# Crea directorios para los archivos de configuración
RUN mkdir -p /etc/openvpn/client /etc/squid

# Copia los archivos de configuración de OpenVPN y Squid
COPY client*.ovpn /etc/openvpn/client/
COPY squid*.conf /etc/squid/

# Expone los puertos para Squid
EXPOSE 3128 3129

# Script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Comando para ejecutar al iniciar el contenedor
CMD ["/start.sh"]