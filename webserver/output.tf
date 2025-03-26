output "public_ips" {
  value = aws_instance.public[*].public_ip
}

output "public_ip_bastion" {
  value = aws_instance.bastion[*].public_ip
}

output "private_ips" {
  value = aws_instance.private[*].private_ip
}
