provider "aws" {
  profile = "terraform"
  region  = "eu-north-1"
}

resource "aws_s3_bucket" "tf_course" {
  bucket = "tf-course-mj"
  acl    = "private"
}
