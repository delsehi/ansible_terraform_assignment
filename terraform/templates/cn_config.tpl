#cloud-config
package_update: true
package_upgrade: true
packages:
  - ansible
  - python
write_files:
  - content: |
      [mariadb]
      ${master_db_ip}
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
