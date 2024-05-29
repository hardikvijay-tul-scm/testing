output "centraleks_privatesubnets" {
  value = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id, aws_subnet.centraleks_privatesubnet4.id, aws_subnet.centraleks_privatesubnet5.id, aws_subnet.centraleks_privatesubnet6.id]
}
output "cluster_sec_group" {
  value = [module.eks.cluster_security_group_id]
}
