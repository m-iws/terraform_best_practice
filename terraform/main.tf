# ------------------------------------------------------------#
#  s3
# ------------------------------------------------------------#
resource "aws_s3_bucket" "terraform_study_s3" {
  bucket = "terraform-study-20240609"
  tags = {
    Name = "${var.tag_name}-s3"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket                  = aws_s3_bucket.terraform_study_s3.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ------------------------------------------------------------#
#  EC2
# ------------------------------------------------------------#

resource "aws_instance" "ec2_a" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = var.key_pair
  availability_zone      = "${var.region}a"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.public_sub_a.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = "${var.tag_name}-ec2-a"
  }
}

resource "aws_instance" "ec2_c" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = var.key_pair
  availability_zone      = "${var.region}a"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.public_sub_a.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = "${var.tag_name}-ec2-c"
  }
}

# ------------------------------------------------------------#
#  rds subnet groupe
# ------------------------------------------------------------#
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.tag_name}-db-subnet-group"
  description = "for ${var.tag_name}_db_subnet_group"
  subnet_ids  = [aws_subnet.private_sub_a.id, aws_subnet.private_sub_c.id]
  tags = {
    Name = "${var.tag_name}-db-subnet-group"
  }
}

# ------------------------------------------------------------#
#  rds
# ------------------------------------------------------------#
resource "aws_db_instance" "rds" {
  identifier                  = "${var.tag_name}-rds"
  engine                      = var.rds_engine
  engine_version              = var.rds_engine_version
  multi_az                    = true
  username                    = "foo"
  manage_master_user_password = true
  instance_class              = var.rds_instance_type
  storage_type                = var.rds_storage_type
  allocated_storage           = 20
  db_subnet_group_name        = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible         = false
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  #availability_zone           = "${var.region}a"
  port                       = 3306
  parameter_group_name       = aws_db_parameter_group.db_parameter_group.name
  option_group_name          = aws_db_option_group.db_option_group.name
  backup_retention_period    = 0
  skip_final_snapshot        = true
  auto_minor_version_upgrade = false
  tags = {
    Name = "${var.tag_name}-rds"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${var.tag_name}-db-parameter-group"
  family = var.rds_family
  tags = {
    Name = "${var.tag_name}-db-parameter-group"
  }
}

resource "aws_db_option_group" "db_option_group" {
  name                 = "${var.tag_name}-db-option-group"
  engine_name          = var.rds_engine
  major_engine_version = var.rds_major_engine_version
  tags = {
    Name = "${var.tag_name}-db-option-group"
  }
}
# ------------------------------------------------------------#
#  ALB
# ------------------------------------------------------------#
resource "aws_lb" "alb" {
  name               = "${var.tag_name}-alb"
  load_balancer_type = "application"
  internal           = false
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_sub_a.id, aws_subnet.private_sub_c.id]
  tags = {
    Name = "${var.tag_name}-alb"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.tag_name}-alb-tg-a"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"
  protocol    = "HTTP"
  port        = 80
  health_check {
    protocol = "HTTP"
    path     = "/"
  }
  tags = {
    Name = "${var.tag_name}-alb-tg"
  }
}


resource "aws_lb_target_group_attachment" "alb_target_attach_ec2_a" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.ec2_a.id
}

resource "aws_lb_target_group_attachment" "alb_target_attach_ec2_c" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.ec2_c.id
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = "forward"
  }
  port     = "80"
  protocol = "HTTP"
}

resource "aws_lb_listener_rule" "forward" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
