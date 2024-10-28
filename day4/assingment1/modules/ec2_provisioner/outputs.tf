output "apache_server_ip" {
  value = aws_instance.instance[0].public_ip
}
