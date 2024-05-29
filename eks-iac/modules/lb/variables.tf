variable "lb_name" {
  default = "centraleks-nlb"
}
variable "lb_type" {
  default = "network"
}
variable "lb_subnets" {
  type = list
  default = ["subnet-04f07749d31e8c419", "subnet-000a3573d5115b0ce", "subnet-0c12f3ad7a768c4c4"]  
}
variable "env" {
  default = "qa"
}
variable "app" {
  default = "centraleks"
}
variable "tg_name" {
  default = "centraleks-alb"
}
variable "tg_name_tls" {
  default = "centraleks-alb-tsl"
}
variable "tg_healthcheck_path" {
  default = "/"
}
variable "tg_alb_arn" {
  default = "arn:aws:elasticloadbalancing:ap-south-1:032560443992:loadbalancer/app/k8s-apps-10c224b786/ad35377bf3977e66"
}
variable "vpc_id" {
  default = "vpc-0c67cc3b05e4e3403"
}
variable "cert_arn" {
  default = "arn:aws:iam::032560443992:server-certificate/2023_WILDCARD_TATAUNISTORE_CERTIFICATE"
}
