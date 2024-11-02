variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  default     = "s3-bucket-remith-test-terraform"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "ProductionEC2Instance"
}
