## 1. On master node
- git clone https://github.com/MarcAntoine-AJ/LOG8415E-Final_Assignment.git
- cd LOG8415E-Final_Assignment/MySQL/
- chmod 777 master.sh
- ./master.sh -a "ip-172-31-42-184.ec2.internal" -b "ip-172-31-39-200.ec2.internal" -c "ip-172-31-37-145.ec2.internal" -d "ip-172-31-41-74.ec2.internal"

## 2. On slave node
- git clone https://github.com/MarcAntoine-AJ/LOG8415E-Final_Assignment.git
- cd LOG8415E-Final_Assignment/MySQL/
- chmod 777 slave.sh
- ./slave.sh -a "ip-172-31-42-184.ec2.internal"

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

            [mysql_cluster]
            ndb-connectstring=ip-172-31-36-143.ec2.internal # location of management server

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
