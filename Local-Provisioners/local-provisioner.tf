terraform {
  required_version = ">=0.14"
}

resource "null_resource" "resource_for_local_provisioners" {
  provisioner "local-exec" {
    command = "date"
  }
}