output "bucket-id" {
    description = "ID of the given S3 bucket"
    value = {
        for k, v in aws_s3_bucket.domain-bucket : k => v.id
    }
}

output "bucket-endpoint" {
    description = "The full website endpoint for the bucket, including region"
    value = {
        for k, v in aws_s3_bucket_website_configuration.web-config : k => v.website_endpoint
    }
} 

output "log-bucket-id" {
    description = "Logging bucket ID"
    value = aws_s3_bucket.log-bucket.id
}

output "cloudfront-id" {
    description = "CloudFront distribution ID"
    value = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront-domain" {
    description = "CloudFront distribution domain"
    value = aws_cloudfront_distribution.s3_distribution.domain_name
}