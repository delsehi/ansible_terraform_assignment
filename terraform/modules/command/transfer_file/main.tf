resource "null_resource" "transfer_file" {
  provisioner "file" {
    source      = var.source_file
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
