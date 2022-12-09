import pymysql
from pythonping import ping
from sshtunnel import SSHTunnelForwarder

slaves = []

def connect(slave_ip, master_ip):
    with SSHTunnelForwarder (slave_ip, ssh_username='ubuntu', ssh_pkey='keypair.pem', remote_bind_address=(master_ip, 3306)) as tunnel:
        conn = pymysql.connect(host=master_ip, user='user', password='password', db='sakila', port=3306, autocommit=True)
        print(conn)
        cursor = conn.cursor()
        operation = 'SELECT * FROM actor;'
        cursor.execute(operation)
        print(cursor.fetchall())
        return conn

def ping_host(host):
    return ping(target=host, count=1, timeout=2).rtt_avg_ms

def lowest_res_slave():
    response_times = [ping_host(slave) for slave in slaves]
    fastest_slave = min(range(len(response_times)), key=response_times.__getitem__)
    return fastest_slave

management_node_ip = '54.158.41.150'
data_node_ip = '34.204.84.12'
connection = connect(data_node_ip, management_node_ip)

