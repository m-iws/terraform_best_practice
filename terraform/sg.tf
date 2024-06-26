# ------------------------------------------------------------
#  Security Group
# ------------------------------------------------------------
# web security group
resource "aws_security_group" "ec2_sg" {
  name        = "${var.tag_name}-ec2-sg"
  description = "for ec2"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.tag_name}-ec2-sg"

  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ec2_sg_elb" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.vpc_allow
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ec2_sg_ssh" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.vpc_allow
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ec2_sg_app" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.vpc_allow
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

resource "aws_vpc_security_group_egress_rule" "allow_egree_ec2_sg" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.vpc_allow
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# rds security group
resource "aws_security_group" "rds_sg" {
  name        = "${var.tag_name}-rds_sg"
  description = "for rds"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.tag_name}-rds_sg"

  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_rds_sg" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_egree_rds_sg" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# alb security group
resource "aws_security_group" "alb_sg" {
  name        = "${var.tag_name}-alb_sg"
  description = "for alb"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.tag_name}-alb_sg"

  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_sg" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_egree_alb_sg" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
