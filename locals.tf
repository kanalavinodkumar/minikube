locals {
  public_subnet_id = aws_subnet.public_subnet.id
  workstation_public_ip = aws_instance.workstation.public_ip
}

output "workstation_public_ip" {
  value = local.workstation_public_ip
}