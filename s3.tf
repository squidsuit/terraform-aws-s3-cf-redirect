resource "aws_s3_bucket" "bucket" {
    for_each = {
        fqdn = "${var.domain_name}",
        www-fqdn = "www.${var.domain_name}"
    }

    bucket = each.value
    acl    = "public-read"

    versioning {
        enabled = true
    }

    website {
        redirect_all_requests_to = var.redirect_target
    }

    logging {
        target_bucket = aws_s3_bucket.logbucket.id
        target_prefix = "log/${each.value}/"
    }

    server_side_encryption_configuration {
        rule {
        apply_server_side_encryption_by_default {
            kms_master_key_id = aws_kms_key.mykey.arn
            sse_algorithm     = "aws:kms"
            }
        }
    }
}

resource "aws_s3_bucket" "logbucket" {
    bucket = "${var.domain_name}-logs"
    acl = "log-delivery-write"

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
        apply_server_side_encryption_by_default {
            kms_master_key_id = aws_kms_key.mykey.arn
            sse_algorithm     = "aws:kms"
            }
        }
    }

}

resource "aws_kms_key" "mykey" {
  description             = "Encrypt those bucket's contents."
  deletion_window_in_days = 14
  enable_key_rotation = true
}