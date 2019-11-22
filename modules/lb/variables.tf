### =================================================================== REQUIRED

variable "vpc_id" {
  type        = "string"
  description = "the ID of the VPC"
}

variable "install_id" {
  type        = "string"
  description = "the ID of the install"
}

variable "public_subnets" {
  type        = "list"
  description = "list of public subnets"
}

variable "public_subnets_cidr_blocks" {
  type        = "list"
  description = "list of CIDRs for the public subnets"
}

variable "private_subnets_cidr_blocks" {
  type        = "list"
  description = "list of CIDRs for the private subnets"
}

## `*.${var.domain}` in ACM, `${var.domain}` in route53
variable "domain" {
  type        = "string"
  description = "this is used to find an existing issued wildcard cert and route53 zone"
}

variable "hostname" {
  type        = "string"
  description = "hostname to assign to cluster under domain (default is autogenerated one)"
  default     = ""
}

variable "update_route53" {
  type        = "string"
  description = "indicate if route53 should be updated automatically"
  default     = true
}

variable "cert_arn" {
  type        = "string"
  description = "Amazon Resource Name (ARN) for Certificate in the ACM you'd like to use (default uses domain or cert_domain to look it up)"
  default     = ""
}

variable "cert_domain" {
  type        = "string"
  description = "domain to search for ACM certificate with (default is *.domain)"
  default     = ""
}

variable "create_cert" {
  description = "indicate if a cert should be created"
  default = false
}

variable "prefix" {
  type        = "string"
  description = "Prefix for resources"
}

variable "project_name" {
  description = "name to attach to external services components"
}

### =================================================================== OPTIONAL

### ======================================================================= MISC

## issued certificate that the lb will be configured to use
/*data "aws_acm_certificate" "lb" {
  count = "${var.create_cert ? 0 : 1}"
  domain      = "${var.cert_domain != "" ? var.cert_domain : "*.${var.domain}"}"
  statuses    = ["ISSUED"]
  most_recent = true
}*/

## existing route53 zone where we'll create an alias to the lb
data "aws_route53_zone" "zone" {
  count = "${var.update_route53 ? 1 : 0}"
  name  = "${var.domain}"
}

locals {
  hostname = "${var.hostname != "" ? var.hostname : "ptfe-${var.install_id}"}"

  ## https://${local.endpoint}/…
  endpoint = "${local.hostname}.${var.domain}"
}
