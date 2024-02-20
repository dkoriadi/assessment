from flask import Flask
from flask import jsonify
import requests

app = Flask(__name__)

EC2_METADATA_URL = "http://169.254.169.254/latest/meta-data"

@app.route('/vend_ip')
def vend_ip():
    response = requests.get(f'{EC2_METADATA_URL}/network/interfaces/macs/')
    mac_address = response.text.strip()
    
    subnet_ip_response = requests.get(f'{EC2_METADATA_URL}/network/interfaces/macs/{mac_address}/subnet-ipv4-cidr-block')
    subnet_ip = subnet_ip_response.text.strip()
    
    # "192.0.2.0/24" in this format
    subnet_ip_addr = subnet_ip.split('/')[0]
    subnet_size = subnet_ip.split('/')[1]    
    data = {
        "ip_address": subnet_ip_addr,
        "subnet_size": f"/{subnet_size}"
    }
    return jsonify(data)

app.run(host='localhost', port=5000)