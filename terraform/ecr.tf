#---------------------------
# ECR repository (gateway)
#---------------------------
resource "aws_ecr_repository" "gateway" {
  name = "gateway-service"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

#---------------------------
# ECR repository (orders)
#---------------------------
resource "aws_ecr_repository" "orders" {
  name = "orders-service"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

#---------------------------
# ECR repository (payments)
#---------------------------
resource "aws_ecr_repository" "payments" {
  name = "payments-service"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}
