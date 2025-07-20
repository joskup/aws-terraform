```hcl
resource "aws_s3_bucket" "artifacts" {
  bucket = "acme-artifacts-${random_id.suffix.hex}"
  acl    = "private"
  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
```
