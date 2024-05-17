# below we creted s3 bucket resource and var.cucketname is name of bucket that we declared in different file.
resource "aws_s3_bucket" "myBucket" {
  bucket = var.bucketname
}

# this block will create a policy for our bucket, which allows full access to the owner only.
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.myBucket.id

  rule { 
    object_ownership = "BucketOwnerPreferred"
  }
}

# we made our bucket public so anyone can read from it.
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.myBucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# we made our bucket public so anyone can read from it.
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.myBucket.id
  acl    = "public-read"
}

# we upload three different objects to  our bucket with their own unique names.
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.myBucket.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.myBucket.id
  key = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.myBucket.id
  key = "download.jpeg"
  source = "download.jpeg"
  acl = "public-read"
}

# we declared that website will display index.html in general case and error.html is displayed if any error occured.
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.myBucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  depends_on = [ aws_s3_bucket_acl.example ]
}

