locals {
  sg = ["public", "bastion", "private"]
}

// Security Group
resource "aws_security_group" "sg" {
  for_each    = toset(local.sg)
  name        = each.value
  description = each.value
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  tags = merge(
    var.tags, {
      Name = "${var.prefix}-${each.value}-sg"
    }
  )
}

// Inbound Rules - HTTP
resource "aws_vpc_security_group_ingress_rule" "allow-inbound-http" {
  for_each          = aws_security_group.sg
  description       = "HTTP"
  security_group_id = each.value.id
  cidr_ipv4         = "0.0.0.0/0" # Allow IPv4 traffic from anywhere
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

// Inbound Rules - SSH
resource "aws_vpc_security_group_ingress_rule" "allow-inbound-ssh" {
  for_each          = aws_security_group.sg
  description       = "SSH"
  security_group_id = each.value.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  // Conditionally assign values
  cidr_ipv4                    = each.key == "private" ? null : "0.0.0.0/0"
  referenced_security_group_id = each.key == "private" ? aws_security_group.sg["bastion"].id : null
}

// Outbound Rules - All Traffic
resource "aws_vpc_security_group_egress_rule" "allow-outbound-all" {
  for_each          = aws_security_group.sg
  description       = "Allow all outbound traffic"
  security_group_id = each.value.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" // all protocols
}
