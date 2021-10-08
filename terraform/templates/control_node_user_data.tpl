#!/bin/bash
sudo mkdir /etc/ansible
sudo tee /etc/ansible/hosts << EOF
[mariadb]
${master_db_ip}
EOF

sudo apt-get update
sudo apt-get install ansible -y

