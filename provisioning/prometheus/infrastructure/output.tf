
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.prometheus_instance.public_ip
}
output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.prometheus_instance.private_ip
}