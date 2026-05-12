resource "aws_cloudwatch_log_group" "gateway" {
  name              = "/ecs/gateway-service"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "orders" {
  name              = "/ecs/orders-service"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "kafka" {
  name              = "/ecs/kafka-service"
  retention_in_days = 1
}
