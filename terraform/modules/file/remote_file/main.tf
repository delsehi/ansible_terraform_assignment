resource "null_resource" "remote_file" {
  provisioner "file" {
    content     = var.content
    destination = var.destination_file
  }

  connection {
    host        = var.remote_host
    type        = var.connection_type
    user        = var.user
    private_key = var.private_key
    agent       = false
  }
}
