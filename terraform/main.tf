terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

# Start ansible playbook
resource "null_resource" "start_ansible" {

  provisioner "remote-exec" {
    connection {
      host        = openstack_networking_floatingip_v2.control_node_fip.address
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key)
      agent       = "false"
    }

    inline = [
      "ansible-galaxy install -r /home/ubuntu/requirements.yml",
      "ansible-playbook 2dv*/ansible/playbook.yml"
    ]
  }

  depends_on = [
    null_resource.transfer_backupsql,
    null_resource.transfer_xmlimport,
    null_resource.transfer_loadbalancerfip,
  ]
}