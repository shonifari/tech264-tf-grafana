
output "controller_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.grafana_prometheus_instance.public_ip
}
output "grafana_dashboard" {
  value       = "http://${aws_instance.grafana_prometheus_instance.public_ip}:3000"
}
output "prometheus_dashboard" {
  value       = "http://${aws_instance.grafana_prometheus_instance.public_ip}:9090"
}
output "node_exporter_dashboard" {
  value       = "http://${aws_instance.grafana_prometheus_instance.public_ip}:9100"
}