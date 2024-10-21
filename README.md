# AWS S3 Static Website Hosting Project using Terraform

This project showcases how to host a static website using Amazon S3, from bucket creation to configuring it for public access using Terraform.

## 📋 Project Summary

- **Service Used**: Amazon S3 (Simple Storage Service), Terraform
- **Region**: Europe (London) – eu-west-2
- **Files Hosted**: HTML and image assets

## ⚙️ Steps to Complete

### 1. **Download and Install Terraform and AWS CLI**  
   As this was my first-ever Terraform project, I needed to download Terraform and AWS CLI. I ensured to install them in the correct directory to avoid any path-related issues during execution.
   I then connected to my AWS account using my access key ID and secret access key.
   
### 2. Provider Configuration

The AWS provider is configured to use the London region.
```hcl
provider "aws" {
  region = "eu-west-2" # London
}
```
### 3. Create the s3 bucket
  The S3 bucket is created with a globally unique name and tagged for better identification.
```hcl
resource "aws_s3_bucket" "website_bucket" {
  bucket = "ali-saiyed-s3bucket" # Ensure this is globally unique

  tags = {
    Name        = "Static Website Bucket"
    Environment = "Dev"
  }
}
```
### 4. Configure the Bucket for Static Website Hosting
The bucket is configured to host a static website by specifying the index document.

```hcl
Copy code
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }
}
```
### 5. Set Public Access Settings
Public access settings are configured to allow public read access.

```hcl
Copy code
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}
```
### 6. Upload index.html to the S3 Bucket
The static website's main HTML file is uploaded to the S3 bucket.

```hcl
Copy code
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "C:/Users/saiya/OneDrive/Documents/IT Progression/Terraform/terraform-project-s3/index.html"
  content_type = "text/html"
}
```
### 7. Bucket Policy for Public Read Access
A bucket policy is set to allow public read access to the objects in the S3 bucket.

```hcl
Copy code
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
```
## 🔧 Challenges & Solutions

### Issue: Access Denied Error

Description: Initially, I encountered a 403 Access Denied error while trying to set the bucket policy.
Solution: I ensured that the public access settings in the S3 bucket were correctly configured, and I granted full S3 access in IAM.

### Issue: Deprecated Attributes

Description: Some attributes in the Terraform code, such as acl and website, were marked as deprecated.
Solution: I updated the code to use the latest recommended attributes as per Terraform documentation.

### Issue: Local File Path Errors

Description: There were issues with specifying the local path for uploading files.
Solution: I ensured that the file paths were correctly specified using forward slashes and included the full path.

## 🌐 Conclusion
This project demonstrates how to set up a static website hosting solution using AWS S3 and Terraform. It is a great way to familiarise yourself with terraform and AWS services as a beginner. Feel free to fork this repository and adapt it to your needs!

### Dont forget to terraform destroy resources to avoid incurring extra charges from AWS

## 📄 License
This project is licensed under the MIT License.
