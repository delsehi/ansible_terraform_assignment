resource "null_resource" "command" {

  provisioner "remote-exec" {
    connection {
      host        = var.remote_host
      type        = var.connection_type
      user        = var.user
      private_key = var.private_key
      agent       = "false"
    }

    inline = [
      var.command
    ]
  }
}
