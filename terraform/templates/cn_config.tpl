#cloud-config
package_update: true
package_upgrade: true
packages:
  - ansible
  - python
  - unzip
write_files:
  - content: |
      [mariadb]
      ${master_db_ip}
      ${slave_db_ip}

      [file server]
      ${file_server_ip}
      
      [wordpress]
%{ for node in wp_nodes ~}
      ${node.network[0].fixed_ip_v4}
%{ endfor ~}
    path: /etc/ansible/hosts
    append: true
ssh_keys:
  rsa_private: |
    ${private_key}
  rsa_public: ${public_key}
runcmd:
  - 'curl --header "Private-Token: ${access_token}" "${api_url}" --output /home/ubuntu/repo'
  - 'unzip /home/ubuntu/repo -d /home/ubuntu'