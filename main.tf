
locals {
  uname = var.unique_suffix ? lower("${var.cluster_name}-${random_string.uid.result}") : lower(var.cluster_name)
  default_tags = {
    "ClusterType" = "rke2",
  }
  ccm_tags = {
    "kubernetes.io/cluster/${local.uname}" = "owned"
  }
  cluster_data = {
    name       = local.uname
    server_url = var.server_url
    cluster_sg = var.nodepool_security_group_id
    token      = module.statestore.token
  }
}

resource "random_string" "uid" {
  length  = 3
  special = false
  lower   = true
  upper   = false
  numeric = true
}

resource "random_password" "token" {
  length  = 40
  special = false
}

#tfsec:ignore:aws-s3-block-public-acls
#tfsec:ignore:aws-s3-block-public-policy
#tfsec:ignore:aws-s3-ignore-public-acls
#tfsec:ignore:aws-s3-no-public-buckets
#tfsec:ignore:aws-s3-encryption-customer-key
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-specify-public-access-block
module "statestore" {
  source = "git::https://repo1.dso.mil/platform-one/distros/rancher-federal/rke2/rke2-aws-terraform.git//modules/statestore?ref=v2.1.0"
  name   = local.uname
  token  = random_password.token.result
  tags   = merge(local.default_tags, var.tags)
}

resource "aws_ec2_tag" "public_subnet_tag" {
  for_each    = toset(var.subnets)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "public_subnet_cluster_tag" {
  for_each    = toset(var.subnets)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

#  source                      = "git::https://repo1.dso.mil/platform-one/distros/rancher-federal/rke2/rke2-aws-terraform.git//modules/nodepool?ref=v2.1.0"
#  source                      = "git::https://github.com/boozallen/terraform-aws-rke2-cluster//modules/nodepool"
#tfsec:ignore:aws-ec2-enforce-launch-config-http-token-imds
module "servers" {
  source                      = "git::https://github.com/boozallen/terraform-aws-rke2-cluster//modules/nodepool"
  ami                         = var.ami
  asg                         = { min : 1, max : 7, desired : var.servers }
  block_device_mappings       = var.block_device_mappings
  extra_block_device_mappings = var.extra_block_device_mappings
  instance_type               = var.cp_instance_type
  min_elb_capacity            = 1
  name                        = "${local.uname}-server"
  nodepool_security_group_id  = var.nodepool_security_group_id
  iam_instance_profile        = var.iam_instance_profile == "" ? module.iam[0].iam_instance_profile : var.iam_instance_profile
  spot                        = var.spot
  subnets                     = var.subnets
  target_group_arns           = var.elb_target_group_arns
  tags                        = merge({ "Role" = "server", }, local.ccm_tags, var.tags)
  userdata                    = data.template_cloudinit_config.this.rendered
  vpc_id                      = var.vpc_id
  vpc_security_group_ids      = concat([var.nodepool_security_group_id], var.extra_security_group_ids)
  wait_for_capacity_timeout   = var.wait_for_capacity_timeout
}

