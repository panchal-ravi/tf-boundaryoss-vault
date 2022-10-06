module "vault-inbound-sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name                = "${var.deployment_id}-vault-allow_inbound"
  description         = "Allow inbound to vault-server from Internet"
  vpc_id              = var.vpc_id
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8200
      to_port     = 8200
      protocol    = "tcp"
      description = "vault api ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}  
