## 1. On master node
git clone https://github.com/MarcAntoine-AJ/LOG8415E-Final_Assignment.git
cd LOG8415E-Final_Assignment/MySQL/
chmod 777 master.sh
./master.sh -a "ip-172-31-36-143.ec2.internal" -b "ip-172-31-34-188.ec2.internal" -c "ip-172-31-39-26.ec2.internal" -d "ip-172-31-41-85.ec2.internal"

## 2. On slave node
git clone https://github.com/MarcAntoine-AJ/LOG8415E-Final_Assignment.git
cd LOG8415E-Final_Assignment/MySQL/
chmod 777 slave.sh
./slave.sh -a "ip-172-31-36-143.ec2.internal"

## 3. On master node
./master2.sh
sudo dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb
sudo nano /etc/mysql/my.cnf
Append the following :
[mysqld]
ndbcluster  # run NDB storage engine

[mysql_cluster]
ndb-connectstring=ip-172-31-36-143.ec2.internal # location of management server