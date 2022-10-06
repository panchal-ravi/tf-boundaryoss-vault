module "controller-inbound-sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${var.deployment_id}-controller-sg"
  description = "Allow all inbound from private CIDR"
  vpc_id      = var.vpc_id

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = [var.vpc_cidr_block]
  ingress_with_cidr_blocks = [
    {
      from_port   = 9201
      to_port     = 9201
      protocol    = "tcp"
      description = "controller cluster port"
      cidr_blocks = "${var.vpc_cidr_block}"
    }
  ]
  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 9200
      to_port                  = 9200
      protocol                 = "tcp"
      source_security_group_id = module.web-sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}


module "worker-inbound-sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${var.deployment_id}-worker-allow_inbound"
  description = "Allow all inbound from Internet"
  vpc_id      = var.vpc_id

  ingress_rules       = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

module "web-sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${var.deployment_id}-boundary-web-sg"
  description = "Allow all web traffic"
  vpc_id      = var.vpc_id

  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}
