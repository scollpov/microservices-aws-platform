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

      environment = [
        {
          name  = "ORDERS_SERVICE_URL"
          value = "http://orders.microservices.local:8081"
        },
        {
          name  = "PAYMENTS_SERVICE_URL"
          value = "http://payments.microservices.local:8082"
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
          containerPort = 8081
          hostPort      = 8081
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "SPRING_DATASOURCE_URL", value = "jdbc:mysql://${aws_db_instance.orders.address}:3306/ordersdb" },
        { name = "SPRING_DATASOURCE_USERNAME", value = "ordersuser" },
        { name = "SPRING_DATASOURCE_PASSWORD", value = "ChangeMe123!" },
        { name = "KAFKA_ENABLED", value = "true" },
        { name = "SPRING_KAFKA_BOOTSTRAP_SERVERS", value = "kafka.microservices.local:9092" }
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

#------------------------------
# Task definition (payments)
#------------------------------
resource "aws_ecs_task_definition" "payments" {
  family                   = "payments-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "payments"
      image = "${aws_ecr_repository.payments.repository_url}:latest"

      portMappings = [
        {
          containerPort = 8082
          hostPort      = 8082
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "SPRING_DATASOURCE_URL", value = "jdbc:mysql://${aws_db_instance.payments.address}:3306/paymentsdb" },
        { name = "SPRING_DATASOURCE_USERNAME", value = "paymentsuser" },
        { name = "SPRING_DATASOURCE_PASSWORD", value = "ChangeMe123!" },
        { name = "SPRING_KAFKA_BOOTSTRAP_SERVERS", value = "kafka.microservices.local:9092" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.payments.name
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


#------------------------------
# Task definition (kafka)
#------------------------------
resource "aws_ecs_task_definition" "kafka" {
  family                   = "kafka-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "kafka"
      image = "confluentinc/cp-kafka:7.6.1"

      portMappings = [
        {
          containerPort = 9092
          hostPort      = 9092
          protocol      = "tcp"
        },
        {
          containerPort = 9093
          hostPort      = 9093
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "KAFKA_NODE_ID", value = "1" },
        { name = "KAFKA_PROCESS_ROLES", value = "broker,controller" },
        { name = "KAFKA_CONTROLLER_QUORUM_VOTERS", value = "1@kafka.microservices.local:9093" },
        { name = "KAFKA_LISTENERS", value = "PLAINTEXT://:9092,CONTROLLER://:9093" },
        { name = "KAFKA_ADVERTISED_LISTENERS", value = "PLAINTEXT://kafka.microservices.local:9092" },
        { name = "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP", value = "PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT" },
        { name = "KAFKA_CONTROLLER_LISTENER_NAMES", value = "CONTROLLER" },
        { name = "KAFKA_INTER_BROKER_LISTENER_NAME", value = "PLAINTEXT" },
        { name = "CLUSTER_ID", value = "MkU3OEVBNTcwNTJENDM2Qk" },
        { name = "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR", value = "1" },
        { name = "KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR", value = "1" },
        { name = "KAFKA_TRANSACTION_STATE_LOG_MIN_ISR", value = "1" },
        { name = "KAFKA_DEFAULT_REPLICATION_FACTOR", value = "1" },
        { name = "KAFKA_MIN_INSYNC_REPLICAS", value = "1" },
        { name = "KAFKA_AUTO_CREATE_TOPICS_ENABLE", value = "true" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.kafka.name
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
  name                              = "gateway-service"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.gateway.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 120

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

  service_registries {
    registry_arn = aws_service_discovery_service.orders.arn
  }
}

#-------------------------
# ECS Service (payments)
#-------------------------
resource "aws_ecs_service" "payments" {
  name            = "payments-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.payments.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.payments.arn
  }
}

#-------------------------
# ECS Service (kafka)
#-------------------------
resource "aws_ecs_service" "kafka" {
  name            = "kafka-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.kafka.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.kafka.arn
  }
}

#-------------------------
# Discover private DNS
#-------------------------
resource "aws_service_discovery_private_dns_namespace" "main" {
  name = "microservices.local"
  vpc  = aws_vpc.main.id
}

#--------------------------
# Discover service (orders)
#--------------------------
resource "aws_service_discovery_service" "orders" {
  name = "orders"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {}
}

#-----------------------------
# Discover service (payments)
#-----------------------------
resource "aws_service_discovery_service" "payments" {
  name = "payments"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {}
}

#--------------------------
# Discover service (kafka)
#--------------------------
resource "aws_service_discovery_service" "kafka" {
  name = "kafka"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {}
}
