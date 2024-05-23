terraform {
  backend "s3" {
    bucket = "codewithmuh-test-12" # Replace with your actual S3 bucket name
    key    = "EKS/terraform.tfstate"
    region = "us-west-1"
  }
}