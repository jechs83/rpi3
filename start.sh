\#!/bin/bash

# Función para verificar la conexión VPN
check_vpn() {
    if ip addr show tun0 &> /dev/null; then
        echo "VPN conectada"
        return 0
    else
        echo "VPN desconectada"
        return 1
    fi
}

# Función para obtener la IP de la VPN
get_vpn_ip() {
    ip addr show tun0 | grep inet | awk '{print $2}' | cut -d/ -f1
}

# Iniciar OpenVPN
openvpn --config /etc/openvpn/client.conf &

# Esperar a que la conexión VPN se establezca
echo "Esperando a que la conexión VPN se establezca..."
count=0
while ! check_vpn; do
    sleep 5
    count=$((count+1))
    if [ $count -ge 12 ]; then
        echo "Error: No se pudo establecer la conexión VPN después de 60 segundos."
        exit 1
    fi
done

# Obtener la IP de la VPN
VPN_IP=$(get_vpn_ip)
if [ -z "$VPN_IP" ]; then
    echo "Error: No se pudo obtener la IP de la VPN."
    exit 1
fi
echo "IP de la VPN: ${VPN_IP}"

# Configurar el enrutamiento
echo "Configurando el enrutamiento..."
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Habilitar el reenvío de IP
echo 1 > /proc/sys/net/ipv4/ip_forward

# Configurar Squid
echo "Configurando Squid..."
sed -i "s/\${SQUID_PORT}/${SQUID_PORT}/" /etc/squid/squid.conf
sed -i "s/\${VPN_IP}/${VPN_IP}/" /etc/squid/squid.conf

# Iniciar Squid
echo "Iniciando Squid..."
squid -N -d1

# Verificar que Squid está escuchando en el puerto correcto
if ! netstat -tuln | grep :${SQUID_PORT} > /dev/null; then
    echo "Error: Squid no está escuchando en el puerto ${SQUID_PORT}"
    exit 1
fi

echo "Configuración completada. Squid está ejecutándose en el puerto ${SQUID_PORT}"

# Mantener el contenedor activo y verificar la conexión VPN periódicamente
while true; do
    if ! check_vpn; then
        echo "La conexión VPN se ha caído. Reiniciando OpenVPN..."
        killall openvpn
        openvpn --config /etc/openvpn/client.conf &
        
        # Esperar a que la VPN se reconecte
        while ! check_vpn; do
            sleep 5
        done
        
        # Actualizar la IP de la VPN en Squid
        VPN_IP=$(get_vpn_ip)
        sed -i "s/tcp_outgoing_address .*/tcp_outgoing_address ${VPN_IP}/" /etc/squid/squid.conf
        
        # Reiniciar Squid para aplicar los cambios
        squid -k reconfigure
    fi
    sleep 60
done