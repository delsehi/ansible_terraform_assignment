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
write_files:
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
  - 'curl --header "Private-Token: ${access_token}" "${api_url}" --output /home/ubuntu/repo' # Download repo with ansible playbooks
  - 'unzip /home/ubuntu/repo -d /home/ubuntu'
  - 'sudo cp /etc/ssh/ssh_host_rsa_key ~/.ssh/key'
  - 'sudo chmod 444 ~/.ssh/key'