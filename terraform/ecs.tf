#-------------------------
# ECS Cluster
#-------------------------
resource "aws_ecs_cluster" "main" {
  name = "microservices-cluster"
}

#------------------------------
# Task definition (gateway) 
#------------------------------
resource "aws_ecs_task_definition" "gateway" {
  family                   = "gateway-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "gateway"
      image = "${aws_ecr_repository.gateway.repository_url}:latest"

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.gateway.name
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

#------------------------------
# Task definition (orders)
#------------------------------
resource "aws_ecs_task_definition" "orders" {
  family                   = "orders-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "orders"
      image = "${aws_ecr_repository.orders.repository_url}:latest"

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.orders.name
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

#-------------------------
# ECS Service (gateway)
#-------------------------
resource "aws_ecs_service" "gateway" {
  name            = "gateway-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.gateway.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id
    ]

    security_groups = [aws_security_group.ecs_sg.id]

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.gateway_tg.arn
    container_name   = "gateway"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.http]
}

#-------------------------
# ECS Service (orders)
#-------------------------
resource "aws_ecs_service" "orders" {
  name            = "orders-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.orders.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
