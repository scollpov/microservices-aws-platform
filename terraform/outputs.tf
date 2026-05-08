output "user_pool_id" {
  value = aws_cognito_user_pool.pool.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "domain" {
  value = aws_cognito_user_pool_domain.domain.domain
}

output "jwks_url" {
  value = "https://cognito-idp.eu-west-1.amazonaws.com/${aws_cognito_user_pool.pool.id}/.well-known/jwks.json"
}

output "ecr_gateway_repository_url" {
  value = aws_ecr_repository.gateway.repository_url
}

output "ecr_orders_repository_url" {
  value = aws_ecr_repository.orders.repository_url
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}
