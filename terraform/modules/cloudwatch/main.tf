resource "aws_cloudwatch_log_group" "aws-glue-crawlers" {
    name = "/aws-glue/crawlers"
}

resource "aws_cloudwatch_log_group" "ecs-Redis" {
    name = "/ecs/Redis"
}

resource "aws_cloudwatch_log_group" "ecs-Scheduler" {
    name = "/ecs/Scheduler"
}

resource "aws_cloudwatch_log_group" "ecs-Webserver" {
    name = "/ecs/Webserver"
}

resource "aws_cloudwatch_log_group" "ecs-Worker" {
    name = "/ecs/Worker"
}