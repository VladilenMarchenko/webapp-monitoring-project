output "webapp_public_ip" {
  value = aws_instance.webapp.public_ip
  description = "Public IP of web application server"
}

output "monitoring_public_ip" {
  value = aws_instance.monitoring.public_ip
  description = "Public IP of monitoring server"
}

output "webapp_url" {
  value = "http://${aws_instance.webapp.public_ip}:3000"
  description = "URL of the web application"
}

output "grafana_url" {
  value = "http://${aws_instance.monitoring.public_ip}:3000"
  description = "URL of Grafana dashboard"
}
