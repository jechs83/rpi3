# Utiliza una imagen base compatible con Raspberry Pi (Raspbian o Alpine con soporte ARM)
FROM arm64v8/debian:latest



# Instalación de herramientas necesarias
RUN apt-get update && \
    apt-get install -y openvpn squid proxychains curl iproute2 nano

# Copiar archivos de configuración al contenedor
COPY client1.ovpn /etc/openvpn/client1.conf
COPY client2.ovpn /etc/openvpn/client2.conf
COPY squid.conf /etc/squid/squid.conf

# Copiar archivo de configuración de Proxychains
COPY proxychains.conf /etc/proxychains.conf

# Hacer que la herramienta ping esté disponible
RUN apt-get install -y iputils-ping

# Iniciar Squid y OpenVPN
CMD bash -c "openvpn --config /etc/openvpn/client1.conf --daemon && \
             openvpn --config /etc/openvpn/client2.conf --daemon && \
             squid -N -f /etc/squid/squid.conf"