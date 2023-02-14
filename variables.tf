
variable "download" {
  description = "Toggle best effort download of rke2 dependencies (rke2 and aws cli), if disabled, dependencies are assumed to exist in $PATH"
  type        = bool
  default     = true
}

variable "domain" {
  description = "Name of the rke2 cluster to create"
  type        = string
}

variable "cluster_name" {
  description = "Name of the rke2 cluster to create"
  type        = string
}

variable "unique_suffix" {
  description = "Enables/disables generation of a unique suffix to cluster name"
  type        = bool
  default     = false
}

variable "server_url" {
  description = "url of the controlplane"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to create resources in"
  type        = string
}

variable "lb_addresses" {
  description = "List of lb addresses"
  type        = list(string)
  default     = []
}

variable "elb_target_group_arns" {
  description = "List of arns of target groups to add to the controlplane autoscaler"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "List of subnet IDs to create resources in"
  type        = list(string)
}

variable "tags" {
  description = "Map of tags to add to all resources created"
  default     = {}
  type        = map(string)
}

variable "cp_instance_type" {
  type        = string
  default     = "m5a.xlarge"
  description = "Control Plane pool instance type"
}

variable "ami" {
  description = "Server pool ami"
  type        = string
  default     = "ami-08c40ec9ead489470"
}

variable "iam_instance_profile" {
  description = "Server pool IAM Instance Profile, created if left blank (default behavior)"
  type        = string
  default     = ""
}

variable "iam_permissions_boundary" {
  description = "If provided, the IAM role created for the servers will be created with this permissions boundary attached."
  type        = string
  default     = null
}

variable "block_device_mappings" {
  description = "Server pool block device mapping configuration"
  type        = map(string)
  default = {
    "size"      = 30
    "encrypted" = false
  }
}

variable "extra_block_device_mappings" {
  description = "Used to specify additional block device mapping configurations"
  type        = list(map(string))
  default = [
  ]
}

variable "servers" {
  description = "Number of servers to create"
  type        = number
  default     = 3
}

variable "spot" {
  description = "Toggle spot requests for server pool"
  type        = bool
  default     = false
}

variable "ssh_authorized_keys" {
  description = "Server pool list of public keys to add as authorized ssh keys"
  type        = list(string)
  default     = []
}

variable "extra_security_group_ids" {
  description = "List of additional security group IDs"
  type        = list(string)
  default     = []
}

variable "rke2_version" {
  description = "Version to use for RKE2 server nodes"
  type        = string
  default     = "v1.24.4+rke2r1"
}

variable "rke2_config" {
  description = "Additional configuration for config.yaml"
  type        = string
  default     = ""
}

variable "pre_userdata" {
  description = "Custom userdata to run immediately before rke2 node attempts to join cluster, after required rke2, dependencies are installed"
  type        = string
  default     = ""
}

variable "post_userdata" {
  description = "Custom userdata to run immediately after rke2 node attempts to join cluster"
  type        = string
  default     = ""
}

variable "controlplane_allowed_cidrs" {
  description = "Security group allowed cidr ranges for access to the controlplane"
  type        = list(string)
}

variable "enable_ccm" {
  description = "Toggle enabling the cluster as aws aware, this will ensure the appropriate IAM policies are present"
  type        = bool
  default     = true
}

variable "wait_for_capacity_timeout" {
  description = "How long Terraform should wait for ASG instances to be healthy before timing out."
  type        = string
  default     = "10m"
}

variable "nodepool_security_group_id" {
  type    = string
  default = ""
} 

