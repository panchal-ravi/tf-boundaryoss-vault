listener "tcp" {
    address = "${private_ip}:9202"
    purpose = "proxy"
    tls_disable = true
}
  
worker {
    # Name attr must be unique
    public_addr = "${public_ip}"
    name = "demo-worker-1"
    description = "A default worker created for demonstration"
    controllers = [
        "${controller_ip}"
    ]
}

kms "aead" {
    purpose = "worker-auth"
    aead_type = "aes-gcm"
    key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
    key_id = "global_worker-auth"
}