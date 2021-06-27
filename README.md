# S3-CF-REDIRECT

Use Terraform to provision the infrastructure necessary to redirect traffic from one domain name to another. This module provisions S3 buckets, KMS key, CloudFront distribution, Route 53 records, and a ACM certificate. 

## ASSUMPTIONS

- You have an AWS-registered domain name and that you already have a Hosted Zone created in Route 53. 
  - The Hosted Zone details are pulled in via Terraform's *data* source functionality, which allows records to be modified in the Hosted Zone but ultimately leaves the management of the Hosted Zone itself outside of Terraform.
- You are able to create buckets that match the URLs you want to redirect traffic from
  - eg: [www.squidsuit.com](www.squidsuit.com) and [squidsuit.com](squidsuit.com.)
  - If you cannot create bucket names equal to the values set for the variables fqdn and www-fqdn then this process will not fail

## ARCHITECTURE DIAGRAM

![Diagram](https://github.com/squidsuit/terraform-aws-s3-cf-redirect/blob/main/terraform-aws-s3-cf-redirect-diagram.png?raw=true)
