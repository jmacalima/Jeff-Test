# Create the Cognito User Pool
resource "aws_cognito_user_pool" "JeffUserPool" {
  name = "${var.user_pool_name}"

}

# Create the Cognito User Pool Client
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "${var.user_pool_client}"
  user_pool_id = aws_cognito_user_pool.JeffUserPool.id

}