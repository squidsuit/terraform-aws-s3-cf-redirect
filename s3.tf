locals {
    fqdn = var.domain_name
    www-fqdn = "www.${var.domain_name}"
}

resource "aws_s3_bucket" "domain-bucket" {

    for_each = {
        fqdn = local.fqdn
        www-fqdn = local.www-fqdn 
    }
    bucket = each.value

}

resource "aws_s3_bucket" "log-bucket" {

    bucket = "${var.domain_name}-logs"

}

resource "aws_s3_bucket_logging" "log-bucket" {

    for_each = aws_s3_bucket.domain-bucket
    bucket = aws_s3_bucket.domain-bucket[each.key].id

    target_bucket = aws_s3_bucket.log-bucket.id
    target_prefix = "log/${aws_s3_bucket.domain-bucket[each.key].id}/"

}

resource "aws_s3_bucket_acl" "acl-config-domains" {

    for_each = aws_s3_bucket.domain-bucket
    bucket = aws_s3_bucket.domain-bucket[each.key].id
    acl = "public-read"

}

resource "aws_s3_bucket_acl" "acl-config-log" {

    bucket = aws_s3_bucket.log-bucket.id
    acl = "log-delivery-write"

}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt-config" {

    for_each = aws_s3_bucket.domain-bucket
    bucket = aws_s3_bucket.domain-bucket[each.key].id
    rule {
        apply_server_side_encryption_by_default {
            kms_master_key_id = aws_kms_key.mykey.arn
            sse_algorithm     = "aws:kms"
            }
        }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt-config-logbucket" {

    bucket = aws_s3_bucket.log-bucket.id
    rule {
        apply_server_side_encryption_by_default {
            kms_master_key_id = aws_kms_key.mykey.arn
            sse_algorithm     = "aws:kms"
            }
        }

}

resource "aws_s3_bucket_versioning" "version-config" {

    for_each = aws_s3_bucket.domain-bucket
    bucket = aws_s3_bucket.domain-bucket[each.key].id
    
    versioning_configuration {
        status = "Enabled"
    }

}

resource "aws_s3_bucket_versioning" "version-config-logbucket" {

    bucket = aws_s3_bucket.log-bucket.id
    
    versioning_configuration {
        status = "Enabled"
    }

}

resource "aws_s3_bucket_website_configuration" "web-config" {

    for_each = aws_s3_bucket.domain-bucket
    bucket = aws_s3_bucket.domain-bucket[each.key].id
    redirect_all_requests_to {
        host_name = var.redirect_target
    }

}

resource "aws_kms_key" "mykey" {
  description             = "Encrypt those bucket's contents."
  deletion_window_in_days = 14
  enable_key_rotation = true
}
