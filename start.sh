acl localnet src 192.168.8.0/24  # Ajusta según tu red local
http_access allow localnet
http_access allow all
http_port 3128
# Logs y caché
cache deny all
access_log /var/log/squid/access.log squid
