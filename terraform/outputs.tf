output "grafana_url" {
  description = "URL to access Grafana"
  value       = "https://${aws_cloudfront_distribution.grafana.domain_name}"
}

output "alb_dns_name" {
  description = "DNS name of the load balancer (internal)"
  value       = aws_lb.grafana.dns_name
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name for accessing Grafana"
  value       = aws_cloudfront_distribution.grafana.domain_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.grafana.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.grafana.name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for Grafana"
  value       = aws_cloudwatch_log_group.grafana.name
}