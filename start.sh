#!/bin/bash

# Función para iniciar VPN y verificar conexión
start_vpn() {
    config=$1
    port=$2
    echo "Iniciando VPN con configuración $config en puerto $port"
    openvpn --config $config --daemon --socks-proxy 0.0.0.0 $port --log /var/log/openvpn_$port.log --verb 3

    # Esperar a que se establezca la conexión
    for i in {1..30}; do
        if grep -q "Initialization Sequence Completed" /var/log/openvpn_$port.log; then
            echo "VPN en puerto $port conectada exitosamente"
            return 0
        fi
        sleep 1
    done
    echo "Error: No se pudo establecer la conexión VPN en puerto $port"
    echo "Últimas 20 líneas del log de OpenVPN:"
    tail -n 20 /var/log/openvpn_$port.log
    return 1
}

# Iniciar las VPNs
start_vpn /etc/openvpn/vpn1.ovpn 8080
start_vpn /etc/openvpn/vpn2.ovpn 8081

# Verificar que ambas VPNs estén conectadas
if ! grep -q "Initialization Sequence Completed" /var/log/openvpn_8080.log || \
   ! grep -q "Initialization Sequence Completed" /var/log/openvpn_8081.log; then
    echo "Error: Una o ambas VPNs no se conectaron correctamente"
    exit 1
fi

# Iniciar un proxy SOCKS simple para cada VPN
echo "Iniciando proxies SOCKS"
ssh -N -D 0.0.0.0:8080 localhost &
ssh -N -D 0.0.0.0:8081 localhost &

# Mantener el contenedor en ejecución y mostrar logs
tail -f /var/log/openvpn_8080.log /var/log/openvpn_8081.log