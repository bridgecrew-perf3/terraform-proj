output "ssh_key_name" {
  description = "ssh key value"
  value = "${alicloud_key_pair.ecs-test-ssh-key.key_file}"
}
output "login-name" {
  description = "Login username"
  value = "root"
}
output "public-IP" {
  description = "Public IP of ECS"
  value = "${alicloud_instance.test-instance.public_ip}"
}