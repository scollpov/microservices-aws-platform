resource "aws_ecr_repository" "gateway" {
  name = "gateway-service"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

resource "aws_ecr_repository" "orders" {
  name = "orders-service"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}
