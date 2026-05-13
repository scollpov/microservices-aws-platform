#----------------------------
# DB subnet group (orders)
#----------------------------
resource "aws_db_subnet_group" "orders" {
  name = "orders-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

#----------------------------
# DB subnet group (payments)
#----------------------------
resource "aws_db_subnet_group" "payments" {
  name = "payments-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

#----------------------------
# DB instance (orders)
#----------------------------
resource "aws_db_instance" "orders" {
  identifier = "orders-db"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 20

  db_name  = "ordersdb"
  username = "ordersuser"
  password = "ChangeMe123!"

  db_subnet_group_name   = aws_db_subnet_group.orders.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false
}

#----------------------------
# DB instance (payments)
#----------------------------
resource "aws_db_instance" "payments" {
  identifier = "payments-db"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 20

  db_name  = "paymentsdb"
  username = "paymentsuser"
  password = "ChangeMe123!"

  db_subnet_group_name   = aws_db_subnet_group.payments.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false
}
