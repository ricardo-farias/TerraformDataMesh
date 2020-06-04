resource "aws_iam_group" "data-scientists-group" {
  name = "data-scientists"
}

resource "aws_iam_group" "covid-team-group" {
  name = "covid-team"
}

resource "aws_iam_user" "covid-team-member-user" {
  name = "covid-member1"
}

resource "aws_iam_user" "data-scientist-team-user" {
  name = "data-scientist-member1"
}

resource "aws_iam_user_group_membership" "covid-team-assignment" {
  user = aws_iam_user.covid-team-member-user.name

  groups = [
    aws_iam_group.covid-team-group.name,
  ]
}

resource "aws_iam_user_group_membership" "data-scientist-assignment" {
  user   = aws_iam_user.data-scientist-team-user.name
  groups = [aws_iam_group.data-scientists-group.name]
}

output "output" {
  value = [aws_iam_group.covid-team-group.arn, aws_iam_group.data-scientists-group.arn]
}

