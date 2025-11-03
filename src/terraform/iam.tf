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






data "aws_iam_policy_document" "onway_ses_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail"
    ]
    resources = ["*"]
  }
}

module "onway_ses_iam_user" {
  source = "./modules/iam-user"

  name                = "onway-ses-user"
  policy_name         = "OnWaySESPolicy"
  policy              = data.aws_iam_policy_document.onway_ses_policy.json
  generate_access_key = true
}





data "aws_iam_policy_document" "cdn_user_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketAcl",
      "s3:PutBucketAcl"
    ]
    resources = [
      aws_s3_bucket.cdn_bucket.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetObjectAcl",
      "s3:PutObjectAcl"
    ]
    resources = [
      "${aws_s3_bucket.cdn_bucket.arn}/*"
    ]
  }
}

module "onway_cdn_iam_user" {
  source = "./modules/iam-user"

  name                = "onway-cdn-user"
  policy_name         = "OnWayCDNPolicy"
  policy              = data.aws_iam_policy_document.cdn_user_policy.json
  generate_access_key = true
}
