output "boundary_addr" {
  value = module.elb.elb_dns_name
}

output "boundary_controller_ip" {
  value = aws_instance.boundary-controller.private_ip
}

output "boundary_worker_ip" {
  value = aws_instance.boundary-worker.private_ip
}