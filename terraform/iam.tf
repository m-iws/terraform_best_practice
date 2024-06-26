#IAMロール
resource "aws_iam_role" "s3_role" {
  name = "${var.tag_name}-s3_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  description = "Policy to allow EC2 instances to access S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.terraform_study_s3.arn,
          "${aws_s3_bucket.terraform_study_s3.arn}/*"
        ]
      }
    ]
  })
}



#ポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "role-policy-attachment_ec2_s3_role_policy" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.tag_name}-ec2_instance_profile"
  role = aws_iam_role.s3_role.name
}
