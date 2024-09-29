#!/bin/bash
# Iniciar OpenVPN utilizando la configuración proporcionada
openvpn --config ${OPENVPN_CONFIG} &
# Configurar el puerto dinámico de Squid
sed -i "s/^http_port .*/http_port ${SQUID_PORT}/" ${SQUID_CONFIG}
# Iniciar Squid
squid -f ${SQUID_CONFIG}
# Mantener el contenedor activo
tail -f /dev/null