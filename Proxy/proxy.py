import pymysql
import sys
import random
from pythonping import ping
from sshtunnel import SSHTunnelForwarder

def connect(slave_ip, master_ip, query):
    with SSHTunnelForwarder (slave_ip, ssh_username='ubuntu', ssh_pkey='keypair.pem', remote_bind_address=(master_ip, 3306)) as tunnel:
        conn = pymysql.connect(host=master_ip, user='user', password='password', db='sakila', port=3306, autocommit=True)
        print(conn)
        cursor = conn.cursor()
        operation = query
        cursor.execute(operation)
        print(cursor.fetchall())
        return conn

def ping_host(host):
    return ping(target=host, count=1, timeout=2).rtt_avg_ms

def lowest_res_slave(slaves):
    response_times = [ping_host(slave) for slave in slaves]
    fastest_slave = min(range(len(response_times)), key=response_times.__getitem__)
    return fastest_slave

def direct_hit(management_node_ip, query):
    print('Sending Request to : ', management_node_ip)
    connect(management_node_ip, management_node_ip, query)

def random_hit(data_node_choices, management_node_ip, query):
    data_node_ip = random.choice(data_node_choices)
    print('Sending Request to : ', data_node_ip)
    connect(data_node_ip, management_node_ip, query)

def customized_hit(data_nodes, management_node_ip, query):
    lowest_ping_data_node = lowest_res_slave(data_nodes)
    print('Sending Request to : ', lowest_ping_data_node)
    connect(lowest_ping_data_node, management_node_ip, query)

if __name__ == "__main__":
    management_node_ip = sys.argv[1]
    data_node_1_ip = sys.argv[2]
    data_node_2_ip = sys.argv[3]
    data_node_3_ip = sys.argv[4]
    implementation_type =  sys.argv[5]
    query = sys.argv[6]
    if implementation_type == "direct":
        direct_hit(management_node_ip, query)
    elif implementation_type == "random":
        random_hit([data_node_1_ip, data_node_2_ip, data_node_3_ip], management_node_ip, query)
    elif implementation_type == "customized":
        customized_hit([data_node_1_ip, data_node_2_ip, data_node_3_ip],management_node_ip, query)
