terraform {
  backend "s3" {
    bucket  = "terraform-multi-environment-339712988423-us-east-2-tfstate"
    key     = "dev/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true

    # Modern S3-native state locking
    use_lockfile = true

    # Included because the project PDF requires DynamoDB locking
    dynamodb_table = "terraform-multi-environment-locks"
  }
}