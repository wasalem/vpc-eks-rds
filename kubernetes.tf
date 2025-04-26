resource "kubernetes_secret" "db_credentials" {
  metadata {
    name = "db-credentials"
  }

  data = {
    host     = aws_db_instance.default.address
    port     = aws_db_instance.default.port
    username = aws_db_instance.default.username
    password = aws_db_instance.default.password
    dbname   = aws_db_instance.default.db_name
  }
}