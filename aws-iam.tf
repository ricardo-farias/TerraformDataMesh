resource "aws_iam_group" "covid-italy-team-group" {
  name = "covid-italy-team"
}

resource "aws_iam_group" "covid-us-team-group" {
  name = "covid-us-team"
}

resource "aws_iam_user" "covid-us-team-member-user" {
  name = "covid-us-member1"
}

resource "aws_iam_user" "covid-italy-team-member-user" {
  name = "covid-italy-member1"
}

resource "aws_iam_user_group_membership" "covid-team-assignment" {
  user = aws_iam_user.covid-us-team-member-user.name

  groups = [
    aws_iam_group.covid-us-team-group.name,
  ]
}

resource "aws_iam_user_group_membership" "covid-italy-team-assignment" {
  user   = aws_iam_user.covid-italy-team-member-user.name
  groups = [aws_iam_group.covid-italy-team-group.name]
}

output "output" {
  value = [aws_iam_group.covid-us-team-group.arn, aws_iam_group.covid-italy-team-group.arn]
}

