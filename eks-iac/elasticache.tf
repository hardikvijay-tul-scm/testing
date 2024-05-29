resource "aws_elasticache_subnet_group" "redis-sg" {
  name       = var.martech_elasticache_subnetgroup_name
  subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
  tags = {
    Environment = var.env
    Application = "martech"
  }
}

resource "aws_elasticache_replication_group" "martech-redis-rg-cm" {  
  apply_immediately          = true
  automatic_failover_enabled  = true
  replication_group_id        = var.martech_elasticache_id
  node_type                   = var.martech_elasticache_nodetype
  parameter_group_name        = "default.redis7.cluster.on"
  port                        = 6379
  multi_az_enabled            = true
  auto_minor_version_upgrade  = false
  num_node_groups         = 2
  replicas_per_node_group = 1
  #cluster_mode {
  #  replicas_per_node_group = 1
  #  num_node_groups         = 2
  #}
  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
  log_delivery_configuration {
    destination_type = "cloudwatch-logs"
    destination = "martech-redis-cluster-slow-logs"
    log_format = "text"
    log_type = "slow-log"
  }
  log_delivery_configuration {
    destination      = "martech-redis-cluster-engine-logs"
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "engine-log"
  }
  security_group_ids   = [aws_security_group.martech_elasticache.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis-sg.name
  description = "Redis caching for all martech services: Cluster mode"
  tags = {
    Environment = var.env
    Application = "martech"
  }

}

resource "aws_cloudwatch_log_group" "martech_elasticache_slow_logs" {
  name = "martech-redis-cluster-slow-logs"
  retention_in_days = 14
  tags = {
    Environment = var.env
    Application = "martech"
  }
}

resource "aws_cloudwatch_log_group" "martech_elasticache_engine_logs" {
  name = "martech-redis-cluster-engine-logs"
  retention_in_days = 14
  tags = {
    Environment = var.env
    Application = "martech"
  }
}

resource "aws_appautoscaling_target" "martech_elasticache_scaling_target" {
  max_capacity = 10
  min_capacity = 2
  resource_id = "replication-group/martech-redis-prod"
  scalable_dimension = "elasticache:replication-group:NodeGroups"
  service_namespace = "elasticache"
}

resource "aws_appautoscaling_policy" "martech_elasticache_memory_policy" {
  name               = "redis-memory-metric-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.martech_elasticache_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.martech_elasticache_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.martech_elasticache_scaling_target.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ElastiCacheDatabaseMemoryUsageCountedForEvictPercentage"
    }
    target_value       = 70
  }
}

resource "aws_security_group" "martech_elasticache" {
  name        = "martech_elasticache_redis"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "incoming from VPC"
    from_port        = 0
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  ingress {
    description      = "incoming from VPN"
    from_port        = 0
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = ["10.22.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Application = "martech"
  }
}
