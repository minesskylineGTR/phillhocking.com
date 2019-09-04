module "ghost-db" {
  source = "./ghost-database"
  name   = "./ghost-db"

  db_name = var.db_name
  db_user = var.db_user
  db_pass = var.db_pass
  security_groups = [aws_security_group.ghost-db.id]
}

# Set up the Ghost Server
module "ghost-blog" {
  source      = "./ghost-server"
  name        = "./ghost-server"
  domain_name = var.domain_name

  db_host = module.ghost-db.db-host
  db_name = module.ghost-db.db-name
  db_user = module.ghost-db.db-user
  db_pass = module.ghost-db.db-pass
  key_pair_location = var.key_pair_location
  key_pair_name   = var.key_pair_name
  security_groups = [aws_security_group.ghost-server.id]

  cloudfront_ssl_acm_arn = var.cloudfront_ssl_acm_arn
}
