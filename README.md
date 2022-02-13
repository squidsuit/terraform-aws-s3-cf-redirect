# S3-CF-REDIRECT

Use Terraform to provision the infrastructure necessary to redirect traffic from one domain name to another. This module provisions S3 buckets, KMS key, CloudFront distribution, Route 53 records, and a ACM certificate.

## LIMITATIONS

This module has two minor versions, `0.1.x` and `0.2.x`. Each targets a specific AWS Provider version. With version `4.0` of the AWS provider many breaking changes were introduced with the way s3 buckets are managed.

If you are using AWS provider version `3.x` use `0.1.x`. If you are using AWS provider version `4.x` use `0.2.x` of this module.

## ASSUMPTIONS

- You have an AWS-registered domain name and that you already have a Hosted Zone created in Route 53. 
  - The Hosted Zone details are pulled in via Terraform's *data* source functionality, which allows records to be modified in the Hosted Zone but ultimately leaves the management of the Hosted Zone itself outside of Terraform.
- You are able to create buckets that match the URLs you want to redirect traffic from
  - eg: [www.squidsuit.com](https://www.squidsuit.com) and [squidsuit.com](https://squidsuit.com.)
  - If you cannot create bucket names equal to the values set for the variables fqdn and www-fqdn then this process will not fail

## ARCHITECTURE DIAGRAM

![Diagram](https://github.com/squidsuit/terraform-aws-s3-cf-redirect/blob/main/terraform-aws-s3-cf-redirect-diagram.png?raw=true)
