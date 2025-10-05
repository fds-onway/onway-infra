resource "aws_iam_user" "cloudfront_manager" {
  name = "cloudfront-manager"

  lifecycle {
    ignore_changes = [tags]
  }
}

data "aws_iam_policy_document" "cloudfront_manager" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:Get*",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
      "cloudfront:CreateInvalidation",
      "cloudfront:Get*",
      "cloudfront:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudfront_manager" {
  name   = "CloudfrontManager"
  policy = data.aws_iam_policy_document.cloudfront_manager.json
}

resource "aws_iam_user_policy_attachment" "cloudfront_manager" {
  user       = aws_iam_user.cloudfront_manager.name
  policy_arn = aws_iam_policy.cloudfront_manager.arn
}




resource "aws_iam_access_key" "cloudfront_manager_access_key" {
  user = aws_iam_user.cloudfront_manager.name
}

output "fds_terraform_access_key_id" {
  value = aws_iam_access_key.cloudfront_manager_access_key.id
}

output "fds_terraform_secret_access_key" {
  value     = aws_iam_access_key.cloudfront_manager_access_key.secret
  sensitive = true
}
