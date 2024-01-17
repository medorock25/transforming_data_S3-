resource "aws_s3_bucket" "s3_test" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_access_point" "access_point_test" {
  bucket = aws_s3_bucket.s3_test.id
  name   = "access_point"
}

