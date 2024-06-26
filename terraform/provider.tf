# ------------------------------------------------------------
#  Terraform configuraton
# ------------------------------------------------------------
terraform {
  required_version = ">=1.4.4"
  backend "s3" {
    bucket = "terraform20240609"
    region = "ap-northeast-1"
    key    = "terraform.tfstate"
    dynamodb_table = "TerraformStateLockTable"
    # role_arn オプションを追加
    role_arn = "arn:aws:iam::851725166888:role/terraform"
  }
}
# ------------------------------------------------------------
#  Provider
# ------------------------------------------------------------
provider "aws" {
  region = var.region
  # assume_roleブロックを追加
  assume_role {
    role_arn     = "arn:aws:iam::851725166888:role/terraform"
    session_name = "terraform-session-01"
  }
}
