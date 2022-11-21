# LOG8415E-Final_Assignment

config.ini
[ndbd default]
# Options affecting ndbd processes on all data nodes:
NoOfReplicas=3	# Number of replicas

[ndb_mgmd]
# Management process options:
hostname=ip-172-31-41-206.ec2.internal
datadir=/var/lib/mysql-cluster 	# Directory for the log files

[ndbd]
hostname=ip-172-31-35-71.ec2.internal
NodeId=2			# Node ID for this data node
datadir=/usr/local/mysql/data	# Remote directory for the data files

[ndbd]
hostname=ip-172-31-32-70.ec2.internal
NodeId=3			# Node ID for this data node
datadir=/usr/local/mysql/data	# Remote directory for the data files

[ndbd]
hostname=ip-172-31-37-76.ec2.internal
NodeId=4			# Node ID for this data node
datadir=/usr/local/mysql/data	# Remote directory for the data files

[mysqld]
# SQL node options:
hostname=ip-172-31-41-206.ec2.internal


[mysql_cluster]
# Options for NDB Cluster processes:
ndb-connectstring=ip-172-31-41-206.ec2.internal  # location of cluster manager


[mysqld]
# Options for mysqld process:
ndbcluster                      # run NDB storage engine

[mysql_cluster]
# Options for NDB Cluster processes:
ndb-connectstring=ip-172-31-41-206.ec2.internal  # location of management server




# oltp_read_write
sudo sysbench /usr/share/sysbench/oltp_read_write.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=6 --db-driver=mysql --tables=18 --table-size=10000 prepare

sudo sysbench /usr/share/sysbench/oltp_read_write.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=6 --db-driver=mysql --tables=18 --table-size=10000 run

# oltp_read_write without number of tables
sudo sysbench /usr/share/sysbench/oltp_read_write.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=6 --db-driver=mysql --table-size=100000 prepare

sudo sysbench /usr/share/sysbench/oltp_read_write.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=6 --db-driver=mysql --table-size=100000 run

# oltp_delete.lua
sudo sysbench /usr/share/sysbench/oltp_delete.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=6 --db-driver=mysql --table-size=100000 prepare

sudo sysbench /usr/share/sysbench/oltp_delete.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=6 --db-driver=mysql --table-size=100000 run

# oltp_insert.lua
sudo sysbench /usr/share/sysbench/oltp_insert.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=6 --db-driver=mysql --table-size=100000 prepare

sudo sysbench /usr/share/sysbench/oltp_insert.lua --mysql-user=root --mysql-password='root' --mysql_storage_engine=ndbcluster --mysql-db=sakila --threads=6 --db-driver=mysql --table-size=100000 run



