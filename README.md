# phillhocking.com

This is based off of this howto: https://pragmacoders.com/blog/self-hosting-a-ghost-blog-on-aws however, I had to update everything in here to run with Terraform v 0.12 and re-do a lot of the contents of the modules, so I don't really feel bad about 

You will need a configuration file named `variables.tf` in the root of the main module which I included in the README to hopefully reduce the likelihood of someone unadvertently uploading their credentials. 

```
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
```

email me with questions phillhocking@gmail.com
