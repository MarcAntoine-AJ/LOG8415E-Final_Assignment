## 1. On master node

- git clone https://github.com/MarcAntoine-AJ/LOG8415E-Final_Assignment.git
- cd LOG8415E-Final_Assignment/MySQL/
- chmod 777 master.sh
- ./master.sh -a "mngmt_private_dns" -b "data_node1_private_dns" -c "data_node2_private_dns" -d "data_node3_private_dns"

## 2. On slave node

- git clone https://github.com/MarcAntoine-AJ/LOG8415E-Final_Assignment.git
- cd LOG8415E-Final_Assignment/MySQL/
- chmod 777 slave.sh
- ./slave.sh -a "mngmt_private_dns"

## 3. On master node

- chmod 777 master2.sh
- ./master2.sh
- cd ~
- cd install/
- sudo dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb
- sudo dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb
- sudo nano /etc/mysql/my.cnf
- Append the following :

            [mysqld]
            ndbcluster  # run NDB storage engine
            bind-address=0.0.0.0

            [mysql_cluster]
            ndb-connectstring=mngmt_private_dns # location of management server

- sudo systemctl restart mysql
- sudo systemctl enable mysql

## 4. Verify installation

- mysql -u root -p
- Enter your password
- SHOW ENGINE NDB STATUS \G
- Verify that there are 3 data nodes as expected.

## 5. Setup Sakila

- wget https://downloads.mysql.com/docs/sakila-db.tar.gz
- sudo tar -xvzf sakila-db.tar.gz
- sudo cp -r sakila-db /tmp/
- mysql -u root -p
- SOURCE /tmp/sakila-db/sakila-schema.sql;
- SOURCE /tmp/sakila-db/sakila-data.sql;
- USE sakila;
- SHOW FULL TABLES;
- You should see the sakila tables.

## 6. Add a user for the proxy

- CREATE USER 'usrname'@'proxy_public_ip' IDENTIFIED BY 'password';
- GRANT ALL PRIVILEGES ON _ . _ TO 'usrname'@'proxy_public_ip';

## 7. Benchmarking your cluster or standalone

    sudo sysbench /usr/share/sysbench/oltp_read_write.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=nb_threads --db-driver=mysql --tables=nb_tables --table-size=table_size prepare

    sudo sysbench /usr/share/sysbench/oltp_read_write.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=nb_threads --db-driver=mysql --tables=nb_tables --table-size=table_size run

    sudo sysbench /usr/share/sysbench/oltp_read_write.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=nb_threads --db-driver=mysql --tables=nb_tables --table-size=table_size cleanup
