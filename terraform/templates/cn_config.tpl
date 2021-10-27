#cloud-config
package_update: true
# package_upgrade: true
packages:
  - ansible
  - python
  - unzip
write_files:
  # Ansible inventory
  - content: |
      [local]
      localhost ansible_ssh_host=localhost

      [db]
      dbmaster ansible_ssh_host=${master_db_ip}
      dbslave ansible_ssh_host=${slave_db_ip}

      [fs]
      fs ansible_ssh_host=${file_server_ip}

      [wp]
%{ for node in wp_nodes ~}
      ${node.name} ansible_ssh_host=${node.internal_ip} 
%{ endfor ~}
    path: /etc/ansible/hosts
    append: true
  # Config ansible to use ssh key and not check host
  - content: |
      [defaults]
      private_key_file = ~/.ssh/key
      host_key_checking = False
    path: /etc/ansible/ansible.cfg
  # Ansible roles needed to be installed
  - content: |
      - src: cloudalchemy.prometheus
      - src: community.mysql
      - src: cloudalchemy.alertmanager
    path: /home/ubuntu/requirements.yml
ssh_keys:
  rsa_private: |
    ${private_key}
  rsa_public: ${public_key}
runcmd:
  # Download repo with ansible playbooks
  # - 'curl --header "Private-Token: ${access_token}" "${api_url}" --output /home/ubuntu/repo'
  # - 'unzip /home/ubuntu/repo -d /home/ubuntu'
  # - 'rm -r /home/ubuntu/repo'
  # Set up ssh key for ansible
  - 'cp /etc/ssh/ssh_host_rsa_key home/ubuntu/.ssh/key'
  - 'chmod 444 home/ubuntu/.ssh/key'
  # Install community plugin for mysql in ansible-galaxy
  - 'runuser -l ubuntu -c "ansible-galaxy collection install community.mysql"'