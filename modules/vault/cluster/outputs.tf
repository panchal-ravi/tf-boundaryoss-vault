output "vault_ips" {
  value = {
    private_ip = aws_instance.vault.private_ip,
    public_ip = aws_instance.vault.public_ip
  }
}
