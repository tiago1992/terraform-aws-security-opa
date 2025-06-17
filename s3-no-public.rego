package terraform.aws.s3

deny[msg] {
  input.resource_changes[_].type == "aws_s3_bucket_public_access_block"
  not input.resource_changes[_].change.after.block_public_acls
  msg := "Bucket S3 com ACL pública detectado."
}
