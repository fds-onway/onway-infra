resource "aws_iam_user" "this" {
  name = var.name
}

resource "aws_iam_policy" "policy" {
  name   = var.policy_name != null ? var.policy_name : var.name
  policy = var.policy
}

resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_access_key" "access_key" {
  count = var.generate_access_key ? 1 : 0

  user = aws_iam_user.this.name
}
