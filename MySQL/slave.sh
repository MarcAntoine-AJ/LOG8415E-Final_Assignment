
#!/bin/bash
################################
# Help with parameters
################################
helpFunction()
{
   echo ""
   echo "Usage: $0 -a parameterA"
   echo -e "\t-a Master Private IP DNS name"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:d:" opt
do
   case "$opt" in
      a ) parameterA="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterA" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "$parameterA"

################################
# Install Dependancies
################################
sudo apt update && sudo apt install libclass-methodmaker-perl
cd ~

################################
# Install MySQL
################################
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb

################################
# Create config file
################################
cat <<EOF >my.cnf
[mysql_cluster]
# Options for NDB Cluster processes:
ndb-connectstring=$parameterA  # location of cluster manager
EOF

sudo cp my.cnf /etc/
sudo mkdir -p /usr/local/mysql/data

################################
# Create service file
################################
cat <<EOF >ndbd.service
[Unit]
Description=MySQL NDB Data Node Daemon
After=network.target auditd.service

[Service]
Type=forking
ExecStart=/usr/sbin/ndbd
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
sudo cp ndbd.service /etc/systemd/system/

################################
# Start service
################################
systemctl daemon-reload
systemctl enable ndbd
systemctl start ndbd