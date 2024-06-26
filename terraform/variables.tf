# ------------------------------------------------------------
#  変数設定
# ------------------------------------------------------------
variable "tag_name" {
  type = string
  description = "Tag name for this project."
  default = "terraform-study02"
}

variable "region" {
  type = string
  description = "The name of the region where this project will be used."
  default = "ap-northeast-1"
}

# ------------------------------------------------------------
#  VPC
# ------------------------------------------------------------

variable "vpc_cider" {
  type = string
  description = "ciderblock used in this project."
  default = "10.0.0.0/16"
}

variable "public_sub_a_cider" {
  type = string
  description = "ciderblock used in public_sub_a."
  default = "10.0.0.0/20"
}

variable "public_sub_c_cider" {
  type = string
  description = "ciderblock used in public_sub_c."
  default = "10.0.16.0/20"
}

variable "private_sub_a_cider" {
  type = string
  description = "ciderblock used in private_sub_a."
  default = "10.0.128.0/20"
}

variable "private_sub_c_cider" {
  type = string
  description = "ciderblock used in private_sub_c."
  default = "10.0.144.0/20"
}

variable "vpc_allow" {
  type = string
  description = "Cider block opens everything"
  default = "0.0.0.0/0"
}

# ------------------------------------------------------------
#  ec2
# ------------------------------------------------------------

variable "ec2_ami" {
  type = string
  description = "ami"
  default = "ami-05b37ce701f85f26a"
}

variable "ec2_instance_type" {
  type = string
  description = "ec2 instance type"
  default = "t2.micro"
}

variable "key_pair" {
  type = string
  description = "key pair"
  default = "terraform01"
}

# ------------------------------------------------------------
#  rds
# ------------------------------------------------------------

variable "rds_engine" {
  type = string
  description = "rds engine"
  default = "mysql"
}

variable "rds_family" {
  type = string
  description = "rds family"
  default = "mysql8.0"
}

variable "rds_engine_version" {
  type = string
  description = "rds engine version"
  default = "8.0.35"
}

variable "rds_major_engine_version" {
  type = string
  description = "rds major engine version"
  default = "8.0"
}

variable "rds_instance_type" {
  type = string
  description = "rds instance type"
  default = "db.t3.micro"
}

variable "rds_storage_type" {
  type = string
  description = "rds storage type"
  default = "gp2"
}
