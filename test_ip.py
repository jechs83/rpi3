import requests

# Definimos los proxies
proxies = {
    "proxy1": {
        "http": "http://192.168.8.105:3128",
        "https": "http://192.168.8.105:3128",
    },
    "proxy2": {
        "http": "http://192.168.8.105:3130",
        "https": "http://192.168.8.105:3130",
    },
}

# URL para verificar la IP pública
check_ip_url = "https://api.ipify.org"

# Función para verificar si un proxy está funcionando y obtener la IP pública
def check_proxy(proxy):
    try:
        response = requests.get(check_ip_url, proxies=proxy, timeout=5)
        if response.status_code == 200:
            return response.text
        else:
            return f"Error: Received status code {response.status_code}"
    except requests.RequestException as e:
        return f"Error: {e}"

# Verificamos ambos proxies
proxy1_ip = check_proxy(proxies["proxy1"])
proxy2_ip = check_proxy(proxies["proxy2"])

# Mostramos los resultados
print(f"IP detectada usando el proxy 192.168.8.105:3128: {proxy1_ip}")
print(f"IP detectada usando el proxy 192.168.8.105:3130: {proxy2_ip}")

# Comparar las IPs
if proxy1_ip != proxy2_ip:
    print("Las IPs son diferentes, los proxies funcionan correctamente.")
else:
    print("Las IPs son iguales o uno de los proxies no está funcionando.")