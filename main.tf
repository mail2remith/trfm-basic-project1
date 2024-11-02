resource "aws_iam_role" "s3_access_role" {
  name = "s3-access-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy"
  description = "Policy to allow S3 full access"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_instance" "web_server" {
  ami                    = "ami-06b21ccaeff8cd686"  # Use a valid AMI ID for `us-east-1`
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.s3_access_profile.name
  key_name               = "production-key"  # Replace with your key pair

  tags = {
    Name = var.instance_name
  }

  user_data = <<EOF
  #!/bin/bash
  yum update -y
  yum install -y aws-cli
  echo "EC2 instance is set up and ready to communicate with S3."
  EOF
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "TerraformS3Bucket"
  }
}

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3-access-profile"
  role = aws_iam_role.s3_access_role.name
}
