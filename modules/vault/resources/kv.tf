resource "vault_mount" "kvv2" {
  path        = "secret"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "secret" {
  mount               = vault_mount.kvv2.path
  name                = "backend-sshkey"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      username    = "ubuntu",
      private_key = file("${path.root}/private-key/rp-key.pem")
    }
  )
}

resource "vault_kv_secret_v2" "uid_pwd" {
  mount               = vault_mount.kvv2.path
  name                = "app-secret"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      username = "ubuntu",
      password = "mysecretpassword"
    }
  )
}
