import pymysql
import sys
import random
from pythonping import ping

slaves = []

def connect_sql(host, bind_add):
    # Connect to the database
    #host : Master
    #bind_address
    connection = pymysql.connect(
        host=host,
        user='root',
        password='root',
        database='sakila',
        port=1186,
        cursorclass=pymysql.cursors.DictCursor,
        bind_address=bind_add
    )

    return connection

def ping_host(host):
    return ping(target=host, count=1, timeout=2).rtt_avg_ms

def lowest_res_slave():
    response_times = [ping_host(slave) for slave in slaves]
    fastest_slave = min(range(len(response_times)), key=response_times.__getitem__)
    return fastest_slave


if __name__ == "__main__":
    mode, master, slave1, slave2, slave3 = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]
    slaves = [slave1, slave2, slave3]
    connection = None
    if mode == 'random':
         connection = connect_sql(master, random.choice(slave1, slave2, slave3))
    elif mode == 'ping':
        connection = connect_sql(master, lowest_res_slave())
    else:
        connection = connect_sql(master, None)

    


