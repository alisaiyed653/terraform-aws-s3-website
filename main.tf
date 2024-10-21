provider "aws" {
  region = "eu-west-2" # London
}

# Create the S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = "ali-saiyed-s3bucket" # Ensure this is globally unique

  tags = {
    Name        = "Static Website Bucket"
    Environment = "Dev"
  }
}

# Configure the bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  
}

# Set public access settings for the bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

# Upload index.html to the S3 bucket
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "C:/Users/saiya/OneDrive/Documents/IT Progression/Terraform/terraform-project-s3/index.html"
  content_type = "text/html"
}

# Bucket policy to allow public read access to the objects
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}
