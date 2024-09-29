#!/bin/bash

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
while ! check_vpn; do
    sleep 5
done

# Obtener la IP de la VPN
VPN_IP=$(get_vpn_ip)
echo "IP de la VPN: ${VPN_IP}"

# Configurar el enrutamiento
echo "Configurando el enrutamiento..."
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Habilitar el reenvío de IP
echo 1 > /proc/sys/net/ipv4/ip_forward

# Configurar Squid
sed -i "s/\${SQUID_PORT}/${SQUID_PORT}/" /etc/squid/squid.conf
sed -i "s/\${VPN_IP}/${VPN_IP}/" /etc/squid/squid.conf

# Iniciar Squid
service squid start

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
        service squid restart
    fi
    sleep 60
done