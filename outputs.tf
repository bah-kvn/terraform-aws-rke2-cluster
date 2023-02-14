
output "cluster_name" {
  description = "Name of the rke2 cluster"
  value       = local.uname
}

output "domain" {
  description = "base domain to use when creating subdomain for the cluster load balancer"
  value       = var.domain
}

# This output is intentionaly blackboxed from the user, make separate outputs intended for user consumption
output "cluster_data" {
  description = "Map of cluster data required by agent pools for joining cluster, do not modify this"
  value       = local.cluster_data
}

output "cluster_sg" {
  description = "Security group shared by cluster nodes, this is different than nodepool security groups"
  value       = local.cluster_data.cluster_sg
}

output "server_url" {
  description = "url of the control plane load balancer"
  value       = local.cluster_data.server_url
}

output "server_sg" {
  description = "security group for servers"
  value       = try(aws_security_group.server[0].id, null)
}

output "server_nodepool_id" {
  description = "id of the nodepool used in the autoscaler"
  value       = module.servers.asg_id
}

output "server_nodepool_name" {
  description = "name of the nodepool used in the autoscaler"
  value       = module.servers.asg_name
}

output "server_nodepool_arn" {
  description = "arn of the autoscaler"
  value       = module.servers.asg_arn
}

output "iam_role" {
  description = "IAM role of server nodes"
  value       = var.iam_instance_profile == "" ? module.iam[0].role : var.iam_instance_profile
}

output "iam_instance_profile" {
  description = "IAM instance profile attached to server nodes"
  value       = var.iam_instance_profile == "" ? module.iam[0].iam_instance_profile : var.iam_instance_profile
}

output "iam_role_arn" {
  description = "IAM role arn of server nodes"
  value       = var.iam_instance_profile == "" ? module.iam[0].role_arn : var.iam_instance_profile
}

output "kubeconfig_path" {
  description = "path to the kubeconfig file in s3"
  value       = "s3://${module.statestore.bucket}/rke2.yaml"
}

output "kubeconfig_bucket" {
  description = "name of the bucket hostingn the kubeconfig"
  value       = module.statestore.bucket
}

output "kubeconfig_filename" {
  description = "filename of the kubeconfig file"
  value       = "rke2.yaml"
}

output "cidr" {
  description = "cidr of the vpc"
  value       = data.aws_vpc.this.cidr_block
}

output "cluster_hosted_zone_id" {
  description = "route 53 hosted zone id "
  value       = data.aws_route53_zone.this.zone_id
}

