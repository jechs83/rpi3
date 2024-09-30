# Utiliza una imagen base compatible con Raspberry Pi
FROM arm32v7/debian:latest

# Instalación de herramientas necesarias
RUN apt-get update && \
    apt-get install -y openvpn squid curl iproute2 nano iputils-ping

# Copiar archivos de configuración al contenedor
COPY client.ovpn /etc/openvpn/client.conf
COPY squid.conf /etc/squid/squid.conf

# Iniciar OpenVPN y Squid
CMD bash -c "openvpn --config /etc/openvpn/client.conf --daemon && squid -N -f /etc/squid/squid.conf"