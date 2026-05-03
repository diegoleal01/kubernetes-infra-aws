terraform {
  backend "s3" {
    bucket       = "BUCKET_NAME"
    key          = "TFSTATE_KEY"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
