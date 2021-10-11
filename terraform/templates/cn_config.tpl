#cloud-config
package_update: true
package_upgrade: true
packages:
  - ansible
  - python
  - unzip
write_files:
  - content: |
      [db]
      ${master_db_ip}
      ${slave_db_ip}

      [fs]
      ${file_server_ip}

      [wp]
%{ for node in wp_nodes ~}
      ${node.network[0].fixed_ip_v4} 
%{ endfor ~}
    path: /etc/ansible/hosts
    append: true
  - content: |
      [defaults]
      private_key_file = ~/.ssh/key
      host_key_checking = False
    path: /etc/ansible/ansible.cfg
ssh_keys:
  rsa_private: |
    ${private_key}
  rsa_public: ${public_key}
runcmd:
  # Download repo with ansible playbooks
  - 'curl --header "Private-Token: ${access_token}" "${api_url}" --output /home/ubuntu/repo'
  - 'unzip /home/ubuntu/repo -d /home/ubuntu'
  - 'rm -r /home/ubuntu/repo'
  # Set up ssh key for ansible
  - 'cp /etc/ssh/ssh_host_rsa_key home/ubuntu/.ssh/key'
  - 'chmod 444 home/ubuntu/.ssh/key'