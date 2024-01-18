## S3 Bucket
resource "aws_s3_bucket" "s3_test" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

## Creating access Point

resource "aws_s3_access_point" "access_point_test" {
  bucket = aws_s3_bucket.s3_test.id
  name   = "access_point"
}

## Object lambda access Point
resource "aws_s3control_object_lambda_access_point" "refund" {
  name = "example"

  configuration {
    supporting_access_point = aws_s3_access_point.access_point_test.arn

    transformation_configuration {
      actions = ["GetObject"]

      content_transformation {
        aws_lambda {
          function_arn = aws_lambda_function.example.arn
        }
      }
    }
  }
}
