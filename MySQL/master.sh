#!/bin/bash

################################
# Help with parameters
################################
helpFunction()
{
   echo ""
   echo "Usage: $0 -a parameterA -b parameterB -c parameterC -d parameterD"
   echo -e "\t-a Master Private IP DNS name"
   echo -e "\t-b Slave 1 Private IP DNS name"
   echo -e "\t-c Slave 2 Private IP DNS name"
   echo -e "\t-d Slave 3 Private IP DNS name"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:d:" opt
do
   case "$opt" in
      a ) parameterA="$OPTARG" ;;
      b ) parameterB="$OPTARG" ;;
      c ) parameterC="$OPTARG" ;;
      d ) parameterD="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterA" ] || [ -z "$parameterB" ] || [ -z "$parameterC" ] || [ -z "$parameterD" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "$parameterA"
echo "$parameterB"
echo "$parameterC"
echo "$parameterD"


################################
# Install Dependancies
################################
sudo apt update && sudo apt install libaio1 libmecab2 libncurses5 dos2unix sysbench expect -y
cd ~

################################
# Install MySQL
################################
sudo wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo mkdir /var/lib/mysql-cluster


################################
# Create config file
################################
cat <<EOF >config.ini
[ndbd default]
# Options affecting ndbd processes on all data nodes:
NoOfReplicas=3	# Number of replicas

[ndb_mgmd]
# Management process options:
hostname=$parameterA  # Hostname of the manager
datadir=/var/lib/mysql-cluster          # Directory for the log files
NodeId=1

[ndbd]
hostname=$parameterB   # Hostname/IP of the first data node
NodeId=2			                    # Node ID for this data node
datadir=/usr/local/mysql/data	        # Remote directory for the data files

[ndbd]
hostname=$parameterC  # Hostname/IP of the second data node
NodeId=3			                    # Node ID for this data node
datadir=/usr/local/mysql/data	        # Remote directory for the data files

[ndbd]
hostname=$parameterD  # Hostname/IP of the second data node
NodeId=4			                    # Node ID for this data node
datadir=/usr/local/mysql/data	        # Remote directory for the data files

[mysqld]
# SQL node options:
hostname=$parameterA
EOF

dos2unix config.ini
sudo cp config.ini /var/lib/mysql-cluster/

################################
# Create service file
################################
cat <<EOF >ndb_mgmd.service
[Unit]
Description=MySQL NDB Cluster Management Server
After=network.target auditd.service

[Service]
Type=forking
ExecStart=/usr/sbin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

dos2unix config.ini
sudo cp ndb_mgmd.service /etc/systemd/system/

################################
# Start service
################################
sudo systemctl daemon-reload 
sudo systemctl enable ndb_mgmd 
sudo systemctl start ndb_mgmd
sudo systemctl status ndb_mgmd