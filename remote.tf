terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-endteehoo"
    key    = "terraform.tfstate"
    region = "us-east-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-teehoolocks"
    encrypt        = true
  }
}