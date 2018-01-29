provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region     = "ap-northeast-1"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "python-demo" {
    function_name = "python-demo"
    handler = "python-demo.lambda_handler"
    runtime = "python2.7"
    filename = "function.zip"
    source_code_hash = "${base64sha256(file("function.zip"))}"
    role = "${aws_iam_role.lambda_exec_role.arn}"

    environment {
      variables = {
        foo = "bar"
      }
    }
}
