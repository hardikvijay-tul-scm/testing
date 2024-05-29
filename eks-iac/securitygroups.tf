module "sg_efs" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.16.0"
  description = "Security group for accessing efs within vpc"
  name        = "centraleks-sg-efs"
  vpc_id      = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port = 2049
      to_port = 2049
      protocol = "tcp"
      description = "NFS Port"
      cidr_blocks = var.vpc_cidr
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Owner = "centraleks"
  }
}

/*
module "sg_vpc_endpoints" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.16.0"
  name        = "centraleks-vpce-sg"
  description = "vpc endpoints security group"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "vpce ingress"
      cidr_blocks = var.vpc_cidr
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Owner = "centraleks"
  }
}
*/
