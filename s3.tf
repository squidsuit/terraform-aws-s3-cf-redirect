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
    # acl    = "public-read"

    # versioning {
    #     enabled = true
    # }

    # website {
    #     redirect_all_requests_to = var.redirect_target
    # }

    # logging {
    #     target_bucket = aws_s3_bucket.logbucket.id
    #     target_prefix = "log/${each.value}/"
    # }

    # server_side_encryption_configuration {
    #     rule {
    #     apply_server_side_encryption_by_default {
    #         kms_master_key_id = aws_kms_key.mykey.arn
    #         sse_algorithm     = "aws:kms"
    #         }
    #     }
    # }
}

resource "aws_s3_bucket_logging" "logbucket" {

    for_each = {
        fqdn = local.fqdn
        www-fqdn = local.www-fqdn 
    }

    bucket = each.value

    target_bucket = aws_s3_bucket.logbucket.id
    target_prefix = "log/${each.value}"

}

resource "aws_s3_bucket_acl" "acl-config-domains" {
    for_each = {
        fqdn = local.fqdn
        www-fqdn = local.www-fqdn 
    }
    
    bucket = each.value
    acl = "public-read"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt-config" {
    for_each = {
        fqdn = local.fqdn
        www-fqdn = local.www-fqdn 
    }

    bucket = each.value
    rule {
    apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
        }
    }

}

resource "aws_s3_bucket_versioning" "version-config" {

    for_each = {
        fqdn = local.fqdn
        www-fqdn = local.www-fqdn
    }

    bucket = each.value
    versioning_configuration {
        status = "Enabled"
    }

}

resource "aws_s3_bucket_website_configuration" "web-config" {

    for_each = {
        fqdn = local.fqdn
        www-fqdn = local.www-fqdn 
    }

    bucket = each.value
    redirect_all_requests_to = var.redirect_target

}

resource "aws_s3_bucket_acl" "acl-config-log" {
    
    bucket = aws_s3_bucket_logging.logbucket.id
    acl = "public-read"
}

resource "aws_s3_bucket" "logbucket" {
    bucket = "${var.domain_name}-logs"
    # acl = "log-delivery-write"

    # versioning {
    #     enabled = true
    # }

    # server_side_encryption_configuration {
    #     rule {
    #     apply_server_side_encryption_by_default {
    #         kms_master_key_id = aws_kms_key.mykey.arn
    #         sse_algorithm     = "aws:kms"
    #         }
    #     }
    # }

}

resource "aws_kms_key" "mykey" {
  description             = "Encrypt those bucket's contents."
  deletion_window_in_days = 14
  enable_key_rotation = true
}