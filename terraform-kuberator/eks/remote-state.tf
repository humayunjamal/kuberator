terraform {
  backend "s3" {
    bucket = "my-bucket"
    key    = "services/eks/tfstate"
    region = "eu-central-1"
  }
}
