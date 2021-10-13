# Create ssh security group
resource "openstack_networking_secgroup_v2" "ssh_secgroup" {
  name        = "ssh_secgroup"
  description = "Security group to allow SSH-traffic"
}

# Create http security group
resource "openstack_networking_secgroup_v2" "http_secgroup" {
  name        = "http_secgroup"
  description = "http security group"
}

# Create security group rules
resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {
  description       = "Security group rule for ssh"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ssh_secgroup.id
}


resource "openstack_networking_secgroup_rule_v2" "http_rule" {
  description       = "Security group rule for http"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.http_secgroup.id
}
