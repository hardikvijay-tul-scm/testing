#Private subnets
resource "aws_subnet" "centraleks_privatesubnet1" {
  vpc_id     = var.vpc_id
  cidr_block = var.privatesubnet_cidrs[0]

  availability_zone = "ap-south-1a"
  tags = {
    Name = "centraleks-privatesubnet-1"
    Owner = "central-eks"
    Environment = "${var.env}-centraleks"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"    
  }
}

resource "aws_subnet" "centraleks_privatesubnet2" {
  vpc_id     = var.vpc_id
  cidr_block = var.privatesubnet_cidrs[1]

  availability_zone = "ap-south-1b"
  tags = {
    Name = "centraleks-privatesubnet-2"
    Owner = "central-eks"
    Environment = "${var.env}-centraleks"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "centraleks_privatesubnet3" {
  vpc_id     = var.vpc_id
  cidr_block = var.privatesubnet_cidrs[2]

  availability_zone = "ap-south-1c"
  tags = {
    Name = "centraleks-privatesubnet-3"
    Owner = "central-eks"
    Environment = "${var.env}-centraleks"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "centraleks_privatesubnet4" {
  vpc_id     = var.vpc_id
  cidr_block = var.privatesubnet_cidrs[3]

  availability_zone = "ap-south-1a"
  tags = {
    Name = "centraleks-privatesubnet-4"
    Owner = "central-eks"
    Environment = "${var.env}-centraleks"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "centraleks_privatesubnet5" {
  vpc_id     = var.vpc_id
  cidr_block = var.privatesubnet_cidrs[4]

  availability_zone = "ap-south-1b"
  tags = {
    Name = "centraleks-privatesubnet-5"
    Owner = "central-eks"
    Environment = "${var.env}-centraleks"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "centraleks_privatesubnet6" {
  vpc_id     = var.vpc_id
  cidr_block = var.privatesubnet_cidrs[5]

  availability_zone = "ap-south-1c"
  tags = {
    Name = "centraleks-privatesubnet-6"
    Owner = "central-eks"
    Environment = "${var.env}-centraleks"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block         = var.rt_cidr_blocks[0]
    transit_gateway_id = var.transit_gw_id
  }
  route {
    cidr_block         = var.rt_cidr_blocks[1]
    transit_gateway_id = var.transit_gw_id
  }
  route {
    cidr_block         = var.rt_cidr_blocks[2]
    transit_gateway_id = var.transit_gw_id
  }
  route {
    cidr_block         = var.rt_cidr_blocks[3]
    transit_gateway_id = var.transit_gw_id
  }
  route {
    cidr_block         = var.rt_cidr_blocks[4]
    transit_gateway_id = var.transit_gw_id
  }
  route {
    cidr_block         = "10.0.0.0/16"
    vpc_peering_connection_id = "pcx-0070b786d99a75e7f"
  }

  tags = {
    Name = "centraleks-rt"
    Owner = "centraleks"
  }
  lifecycle {
    prevent_destroy = true
  }
}

data "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.ap-south-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = data.aws_vpc_endpoint.vpc_endpoint.id
  route_table_id  = aws_route_table.private_route_table.id
  depends_on      = [aws_route_table.private_route_table]
}
/*
data "aws_vpc_endpoint" "vpc_endpoint_ecr_dkr" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.ap-south-1.ecr.dkr"
}

resource "aws_vpc_endpoint_route_table_association" "ecr_dkr" {
  vpc_endpoint_id = data.aws_vpc_endpoint.vpc_endpoint_ecr_dkr.id
  route_table_id  = aws_route_table.private_route_table.id
  depends_on      = [aws_route_table.private_route_table]
}
*/
resource "aws_route_table_association" "rt_association1" {
  subnet_id      = aws_subnet.centraleks_privatesubnet1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_association2" {
  subnet_id      = aws_subnet.centraleks_privatesubnet2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_association3" {
  subnet_id      = aws_subnet.centraleks_privatesubnet3.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_association4" {
  subnet_id      = aws_subnet.centraleks_privatesubnet4.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_association5" {
  subnet_id      = aws_subnet.centraleks_privatesubnet5.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_association6" {
  subnet_id      = aws_subnet.centraleks_privatesubnet6.id
  route_table_id = aws_route_table.private_route_table.id
}

/*resource "aws_vpc_endpoint" "vpce-ec2" {
  depends_on = [module.eks,module.sg_vpc_endpoints]
  service_name = "com.amazonaws.ap-south-1.ec2"
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id
  private_dns_enabled = true
  security_group_ids = [module.sg_vpc_endpoints.security_group_id, module.eks.cluster_security_group_id, var.inviz_sg_id]
  subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
  tags = {
    Name = "centraleks_ec2"
    Owner = "centraleks"
  }
}

resource "aws_vpc_endpoint" "vpce-ecrdkr" {
  depends_on = [module.eks,module.sg_vpc_endpoints]
  service_name = "com.amazonaws.ap-south-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id
  private_dns_enabled = true
  security_group_ids = [module.sg_vpc_endpoints.security_group_id, module.eks.cluster_security_group_id, var.inviz_sg_id]
  subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
  tags = {
    Name = "centraleks_ecrdkr"
    Owner = "centraleks"
  }
}

resource "aws_vpc_endpoint" "vpce-ecrapi" {
  depends_on = [module.eks,module.sg_vpc_endpoints]
  service_name = "com.amazonaws.ap-south-1.ecr.api"
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id
  private_dns_enabled = true
  security_group_ids = [module.sg_vpc_endpoints.security_group_id, module.eks.cluster_security_group_id, var.inviz_sg_id]
  subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
  tags = {
    Name = "centraleks_ecrapi"
    Owner = "centraleks"
  }
}

resource "aws_vpc_endpoint" "vpce-sautoscaling" {
  depends_on = [module.eks,module.sg_vpc_endpoints]
  service_name = "com.amazonaws.ap-south-1.autoscaling"
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id
  private_dns_enabled = true
  security_group_ids = [module.sg_vpc_endpoints.security_group_id, module.eks.cluster_security_group_id, var.inviz_sg_id]
  subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
  tags = {
    Name = "centraleks_autoscaling"
    Owner = "centraleks"
  }
}

resource "aws_vpc_endpoint" "vpce-sts" {
  depends_on = [module.eks,module.sg_vpc_endpoints]
  service_name = "com.amazonaws.ap-south-1.sts"
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id
  private_dns_enabled = true
  security_group_ids = [module.sg_vpc_endpoints.security_group_id, module.eks.cluster_security_group_id, var.inviz_sg_id]
  subnet_ids = [aws_subnet.centraleks_privatesubnet1.id, aws_subnet.centraleks_privatesubnet2.id, aws_subnet.centraleks_privatesubnet3.id]
  tags = {
    Name = "centraleks_sts"
    Owner = "centraleks"
  }
}*/
