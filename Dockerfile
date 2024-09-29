# Base image para Raspberry Pi 3 de 64 bits (ARM64)
FROM arm64v8/debian:bullseye-slim

# Actualizar e instalar las librerías necesarias
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

# Crear directorios para las configuraciones de Squid y OpenVPN
RUN mkdir -p /etc/openvpn /etc/squid

# Copiar los archivos de configuración para OpenVPN y Squid desde el contexto del host
# Nota: Deberás asegurarte de que los archivos estén en el mismo directorio que el Dockerfile al construir la imagen
COPY client1.ovpn /etc/openvpn/client1.conf
COPY client2.ovpn /etc/openvpn/client2.conf
COPY squid1.conf /etc/squid/squid1.conf
COPY squid2.conf /etc/squid/squid2.conf

# Script de arranque que permitirá usar Squid y OpenVPN con diferentes configuraciones
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Exponer los puertos del proxy (3128 y 3129)
EXPOSE 3128
EXPOSE 3129

# Comando de inicio del contenedor
CMD ["/start.sh"]