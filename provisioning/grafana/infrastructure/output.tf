
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.grafana_instance.public_ip
}

output "grafana_dashboard" {
  value       = "http://${aws_instance.grafana_instance.public_ip}:3000"
}