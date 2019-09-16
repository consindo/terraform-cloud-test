data "http" "example" {
  url = "https://api.github.com/repos/dymajo/waka/branches/master"
}

output "git-sha" {
  value = jsondecode(data.http.example.body).commit.sha
}

resource "aws_s3_bucket_object" "object" {
  bucket = "test-assets-us-west-2.waka.app"
  key    = "v.txt"
  content = jsondecode(data.http.example.body).commit.sha

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = md5(jsondecode(data.http.example.body).commit.sha)
}
