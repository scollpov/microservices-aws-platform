# Cloud-Native Microservices Platform (AWS)

## Overview

This project is a cloud-native microservices platform built with Java 21 and Spring Boot following Hexagonal Architecture principles.

The platform demonstrates how to design, containerize, secure, deploy, and operate distributed systems on AWS using modern engineering and DevOps practices.

The project includes:

- API Gateway
- Orders microservice
- Payments microservice
- Event-driven communication with Kafka
- Redis distributed caching with TTL expiration
- Flyway database migrations
- AWS Cognito authentication
- Infrastructure as Code with Terraform
- CI/CD with GitHub Actions
- ECS Fargate deployment
- ECS Fargate auto-scaling based on CPU utilization
- Centralized logging with CloudWatch

GitHub Repository:

```text
https://github.com/scollpov/microservices-aws-platform
```

---

# Architecture

## High-Level Architecture

```text
                    +----------------+
                    |   AWS Cognito  |
                    +--------+-------+
                             |
                             v
+-------------+     +--------+--------+
|   Client    | --> |  API Gateway    |
+-------------+     +--------+--------+
                             |
                +------------+------------+
                |                         |
                v                         v
       +--------+--------+      +---------+--------+
       | Orders Service  |      | Payments Service |
       +---+--------+----+      +---------+--------+
           |        |                     |
           |        v                     |
           |    +---+---+                 |
           |    | Redis |                 |
           |    +-------+                 |
           |                              |
           v                              v
    +------+------+             +---------+--------+
    | Apache Kafka|             | Payments Consumer|
    +-------------+             +------------------+
```

---

# Microservices

## Gateway Service

Responsibilities:

- JWT authentication validation
- Request routing
- Entry point for external clients
- Integration with AWS Cognito

Technology:

- Spring Cloud Gateway
- Spring Security
- JWT Resource Server

---

## Orders Service

Responsibilities:

- Create orders
- Publish `OrderCreatedEvent` to Kafka
- Persist orders in MySQL
- Cache order lookups in Redis

Technology:

- Spring Boot
- Spring Data JPA
- Kafka Producer
- Redis Cache
- Flyway
- MySQL

---

## Payments Service

Responsibilities:

- Consume Kafka events
- Create payment records asynchronously
- Persist payments in MySQL

Technology:

- Spring Boot
- Kafka Consumer
- Flyway
- MySQL

The Payments service follows an event-driven architecture and does not expose public REST APIs.

---

# Hexagonal Architecture

The project follows Hexagonal Architecture (Ports & Adapters) to separate business logic from infrastructure concerns.

Example structure:

```text
application/
├── services
├── ports/in
├── ports/out

adapters/
├── in/rest
├── out/persistence
├── out/messaging

domain/
├── entities
├── business rules
```

Benefits:

- Clear separation of concerns
- Testability
- Technology independence
- Easier maintenance
- Better scalability

---

# Event-Driven Architecture

The platform uses Apache Kafka for asynchronous communication.

Flow:

1. Client creates an order
2. Orders service stores the order
3. Orders service publishes `OrderCreatedEvent`
4. Payments service consumes the event
5. Payments service creates a payment record

Example log:

```text
PAYMENT SAVED: paymentId=6d939314-9690-4868-9d28-3cc17211c745, orderId=10, amount=1000.0, status=PAID
```

---

# Distributed Cache

The Orders service uses Redis distributed caching to reduce database load and improve response times.

Features:

- Cache-aside pattern with `@Cacheable`
- TTL-based expiration
- Shared distributed cache
- Spring Cache abstraction

Flow:

1. First request reads from MySQL
2. Response is cached in Redis
3. Subsequent requests are served from cache

---

# Database Migration

Database schema migrations are managed using Flyway.

Benefits:

- Version-controlled database schema
- Automated migrations during deployment
- Consistent environments
- Safer database evolution

Migration scripts are located under:

```text
src/main/resources/db/migration
```

---

# AWS Infrastructure

Infrastructure is fully provisioned using Terraform.

AWS services used:

- ECS Fargate
- ECS Service Auto Scaling
- ECR
- ALB
- RDS MySQL
- CloudWatch Logs
- Cloud Map Service Discovery
- Cognito
- IAM
- VPC
- Security Groups
- ElastiCache Redis

Infrastructure is defined under:

```text
terraform/
```

---

# Auto Scaling

The ECS Fargate services include CPU-based auto-scaling policies managed with Terraform.

Features:

- Minimum capacity of 1 task per service
- Maximum capacity of 3 tasks per service
- Target tracking policy based on average CPU utilization
- Automatic scale-out and scale-in behavior

Configured services:

- Gateway Service
- Orders Service
- Payments Service

---

# CI/CD Pipeline

GitHub Actions pipelines:

- Execute Maven tests
- Build Docker images
- Push images to Amazon ECR
- Trigger ECS rolling deployments

Each microservice has its own deployment workflow:

```text
.github/workflows/
```

Features:

- OIDC authentication with AWS
- No static AWS keys
- Automatic deployments
- Fail-fast pipeline validation

---

# Security

Authentication and authorization are implemented using AWS Cognito.

Features:

- JWT authentication
- OAuth2 Resource Server
- Protected endpoints
- Secure inter-service communication

---

# Docker

Each service is containerized independently.

Example:

```bash
cd services/orders

docker build -t orders-service .
```

---

# Running Locally

## Prerequisites

- Java 21
- Maven
- Docker
- Terraform
- AWS CLI

---

## Run Orders Service

```bash
cd services/orders
mvn spring-boot:run
```

## Run Payments Service

```bash
cd services/payments
mvn spring-boot:run
```

## Run Gateway

```bash
cd services/gateway
mvn spring-boot:run
```

---

# Example API Request

```bash
curl -X POST http://<ALB>/orders \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
        "id":"10",
        "amount":1000
      }'
```

---

# Observability

Logs are centralized using AWS CloudWatch Logs.

Examples:

```bash
aws logs tail /ecs/orders-service --follow --region eu-west-1
```

```bash
aws logs tail /ecs/payments-service --follow --region eu-west-1
```

---

# Testing

The project includes automated unit test execution through GitHub Actions.

```bash
mvn clean test
```

Pipelines stop automatically if tests fail.

---

# Technologies

## Backend

- Java 21
- Spring Boot
- Spring Security
- Spring Cloud Gateway
- Spring Data JPA
- Kafka
- Redis
- Flyway

## Cloud & DevOps

- AWS ECS Fargate
- AWS Cognito
- AWS ECR
- AWS RDS
- AWS CloudWatch
- AWS ElastiCache Redis
- Docker
- Terraform
- GitHub Actions
- ECS Service Auto Scaling

---

# Author

Sergi Coll Povedano

LinkedIn:

```text
https://www.linkedin.com/in/sergi-coll-b84a3017
```

GitHub:

```text
https://github.com/scollpov
```

