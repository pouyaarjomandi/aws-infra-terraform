terraform {
  backend "s3" {
    bucket       = "myapp-terraform-state-pouya"
    key          = "infrastructure/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}