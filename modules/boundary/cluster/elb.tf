module "elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "3.0.1"
  # insert the 6 required variables here

  name = "${var.deployment_id}-elb"

  subnets         = var.public_subnets
  security_groups = [module.web-sg.security_group_id]
  internal        = false

  listener = [
    {
      instance_port     = 9200
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    }
  ]

  health_check = {
    target              = "HTTP:9200/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  // ELB attachments
  number_of_instances = 1
  instances           = [aws_instance.boundary-controller.id]

  tags = {
    owner = var.owner
  }
}


# resource "aws_security_group_rule" "allow_all" {
#   type                     = "ingress"
#   from_port                = 8500
#   to_port                  = 8500
#   protocol                 = "tcp"
#   prefix_list_ids          = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
#   security_group_id        = module.allow-any-private-inbound-sg.security_group_id
#   source_security_group_id = module.web-sg.security_group_id
# }
