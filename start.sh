#!/bin/bash

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Redirigir la salida estándar y de error a un archivo de log
exec > >(tee -a /var/log/container.log) 2>&1

log "Iniciando script de arranque..."

# Inicia OpenVPN
log "Iniciando OpenVPN..."
openvpn --config /etc/openvpn/client/client1.ovpn --daemon
if [ $? -ne 0 ]; then
    log "Error al iniciar OpenVPN"
    exit 1
fi

# Espera a que la conexión VPN se establezca
log "Esperando que la conexión VPN se establezca..."
sleep 10

# Verifica la conexión VPN
if ! ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    log "Error: No se pudo establecer la conexión VPN"
    exit 1
fi
log "Conexión VPN establecida"

# Inicia Squid en el puerto 3128 con la configuración squid1.conf
log "Iniciando Squid en puerto 3128..."
squid -f /etc/squid/squid1.conf
if [ $? -ne 0 ]; then
    log "Error al iniciar Squid en puerto 3128"
    exit 1
fi

# Inicia Squid en el puerto 3129 con la configuración squid2.conf
log "Iniciando Squid en puerto 3129..."
squid -f /etc/squid/squid2.conf
if [ $? -ne 0 ]; then
    log "Error al iniciar Squid en puerto 3129"
    exit 1
fi

# Verifica que Squid esté escuchando en los puertos correctos
if ! netstat -tuln | grep :3128 > /dev/null; then
    log "Error: Squid no está escuchando en el puerto 3128"
    exit 1
fi
if ! netstat -tuln | grep :3129 > /dev/null; then
    log "Error: Squid no está escuchando en el puerto 3129"
    exit 1
fi
log "Squid está escuchando en los puertos 3128 y 3129"

# Mantén el contenedor en ejecución y muestra los logs de Squid
log "Todos los servicios iniciados correctamente"
tail -f /var/log/squid/access.log /var/log/container.log