resource "aws_efs_file_system" "efs" {
  creation_token = var.efs_token
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = "true"
  tags = {
    Name = "centraleks"
    Environment = "${var.env}-centraleks"
  }
}

resource "aws_efs_mount_target" "efs-mt-1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id =  aws_subnet.centraleks_privatesubnet1.id
  security_groups = [module.sg_efs.security_group_id]
}

resource "aws_efs_mount_target" "efs-mt-2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id = aws_subnet.centraleks_privatesubnet2.id
  security_groups = [module.sg_efs.security_group_id]
}

resource "aws_efs_mount_target" "efs-mt-3" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id =  aws_subnet.centraleks_privatesubnet3.id
  security_groups = [module.sg_efs.security_group_id]
}



resource "aws_efs_file_system" "efs-2" {
  count = var.efs_datascience_req == "yes" ? 1 : 0
  creation_token = var.efs_token_2
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = "true"
  tags = {
    Name = "centraleks"
    Application = "PocketBase-Datascience-Martech"
    Environment = "${var.env}-centraleks"
  }
}

resource "aws_efs_mount_target" "efs-2-mt-1" {
  count = var.efs_datascience_req == "yes" ? 1 : 0
  file_system_id  = aws_efs_file_system.efs-2[count.index].id
  subnet_id =  aws_subnet.centraleks_privatesubnet1.id
}

resource "aws_efs_mount_target" "efs-2-mt-2" {
  count = var.efs_datascience_req == "yes" ? 1 : 0
  file_system_id  = aws_efs_file_system.efs-2[count.index].id
  subnet_id = aws_subnet.centraleks_privatesubnet2.id
}

resource "aws_efs_mount_target" "efs-2-mt-3" {
  count = var.efs_datascience_req == "yes" ? 1 : 0
  file_system_id  = aws_efs_file_system.efs-2[count.index].id
  subnet_id =  aws_subnet.centraleks_privatesubnet3.id
}

resource "aws_efs_file_system" "efs-3" {
  creation_token = var.efs_token_3
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = "true"
  tags = {
    Name = "centraleks"
    Application = "Octopus-Admin-Martech"
    Environment = "${var.env}-centraleks"
  }
}

resource "aws_efs_mount_target" "efs-3-mt-1" {
  file_system_id  = aws_efs_file_system.efs-3.id
  subnet_id =  aws_subnet.centraleks_privatesubnet1.id
  security_groups = [module.sg_efs.security_group_id]
}

resource "aws_efs_mount_target" "efs-3-mt-2" {
  file_system_id  = aws_efs_file_system.efs-3.id
  subnet_id = aws_subnet.centraleks_privatesubnet2.id
  security_groups = [module.sg_efs.security_group_id]
}

resource "aws_efs_mount_target" "efs-3-mt-3" {
  file_system_id  = aws_efs_file_system.efs-3.id
  subnet_id =  aws_subnet.centraleks_privatesubnet3.id
  security_groups = [module.sg_efs.security_group_id]
}
