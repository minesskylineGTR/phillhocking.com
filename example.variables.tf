# AWS Config
variable "aws_access_key" {
  default = "YOUR_ACCESS_KEY_ID"
}

variable "aws_secret_key" {
  default = "YOUR_SECRET_KEY"
}

variable "aws_region" {
  default = "us-west-2"
}

variable "key_pair_name" {
  default = "your_key_name"
}

variable "key_pair_location" {
  default = "~/Documents/your_key_name.pem"
}

# This ACM certificate MUST be in us-east-1
variable "cloudfront_ssl_acm_arn" {
  default = "arn:aws:acm:us-east-1:YOUR_AWS_ID:certificate/YOUR_CERTIFICATE_ID"
}

# Ghost Config
variable "domain_name" {
  default = "my-ghost-blog.com"
}

variable "db_name" {
  default = "ghost_blog_db"
}

variable "db_user" {
  default = "ghost_user"
}

variable "db_pass" {
  default = "593!MyB!og!Ghost!Pass"
}
