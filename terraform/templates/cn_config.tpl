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
  path: /etc/ansible/hosts