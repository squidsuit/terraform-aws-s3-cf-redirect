output "bucket-id" {
    description = "ID of the given S3 bucket"
    value = {
        for k, v in aws_s3_bucket.bucket : k => v.id
    }
}

output "bucket-endpoint" {
    description = "The full website endpoint for the bucket, including region"
    value = {
        for k, v in aws_s3_bucket.bucket : k => v.website_endpoint
    }
} 

output "logbucket-id" {
    description = "Logging bucket ID"
    value = aws_s3_bucket.logbucket.id
}

output "cloudfront-id" {
    description = "CloudFront distribution ID"
    value = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront-domain" {
    description = "CloudFront distribution domain"
    value = aws_cloudfront_distribution.s3_distribution.domain_name
}