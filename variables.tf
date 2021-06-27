variable "domain_name" {
    type = string
    description = "The FQDN that you wish to redirect traffic from"
}

variable "redirect_target" {
    type = string
    description = "The site where you will be directing traffic"
}