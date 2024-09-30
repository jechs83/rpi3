FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    openvpn \
    proxychains \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar archivos de configuración de VPN
COPY vpn1.ovpn /etc/openvpn/vpn1.ovpn
COPY vpn2.ovpn /etc/openvpn/vpn2.ovpn

# Configurar ProxyChains
RUN echo "strict_chain" > /etc/proxychains.conf \
    && echo "proxy_dns" >> /etc/proxychains.conf \
    && echo "[ProxyList]" >> /etc/proxychains.conf \
    && echo "socks5 127.0.0.1 1080" >> /etc/proxychains.conf \
    && echo "socks5 127.0.0.1 1081" >> /etc/proxychains.conf

# Script para iniciar VPNs y proxies
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]