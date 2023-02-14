# Module Name

check out [CONTRIBUTING](./CONTRIBUTING.md) to learn more about this repository

<!-- the follow code is managed by terraform docs -->
<!-- do not modify -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.39.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |
| <a name="requirement_template"></a> [template](#requirement\_template) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.39.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | Server pool ami | `string` | `"ami-08c40ec9ead489470"` | no |
| <a name="input_block_device_mappings"></a> [block\_device\_mappings](#input\_block\_device\_mappings) | Server pool block device mapping configuration | `map(string)` | <pre>{<br>  "encrypted": false,<br>  "size": 30<br>}</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the rke2 cluster to create | `string` | n/a | yes |
| <a name="input_controlplane_allowed_cidrs"></a> [controlplane\_allowed\_cidrs](#input\_controlplane\_allowed\_cidrs) | Security group allowed cidr ranges for access to the controlplane | `list(string)` | n/a | yes |
| <a name="input_cp_instance_type"></a> [cp\_instance\_type](#input\_cp\_instance\_type) | Control Plane pool instance type | `string` | `"m5a.xlarge"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Name of the rke2 cluster to create | `string` | n/a | yes |
| <a name="input_download"></a> [download](#input\_download) | Toggle best effort download of rke2 dependencies (rke2 and aws cli), if disabled, dependencies are assumed to exist in $PATH | `bool` | `true` | no |
| <a name="input_elb_target_group_arns"></a> [elb\_target\_group\_arns](#input\_elb\_target\_group\_arns) | List of arns of target groups to add to the controlplane autoscaler | `list(string)` | `[]` | no |
| <a name="input_enable_ccm"></a> [enable\_ccm](#input\_enable\_ccm) | Toggle enabling the cluster as aws aware, this will ensure the appropriate IAM policies are present | `bool` | `true` | no |
| <a name="input_extra_block_device_mappings"></a> [extra\_block\_device\_mappings](#input\_extra\_block\_device\_mappings) | Used to specify additional block device mapping configurations | `list(map(string))` | `[]` | no |
| <a name="input_extra_security_group_ids"></a> [extra\_security\_group\_ids](#input\_extra\_security\_group\_ids) | List of additional security group IDs | `list(string)` | `[]` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | Server pool IAM Instance Profile, created if left blank (default behavior) | `string` | `""` | no |
| <a name="input_iam_permissions_boundary"></a> [iam\_permissions\_boundary](#input\_iam\_permissions\_boundary) | If provided, the IAM role created for the servers will be created with this permissions boundary attached. | `string` | `null` | no |
| <a name="input_lb_addresses"></a> [lb\_addresses](#input\_lb\_addresses) | List of lb addresses | `list(string)` | `[]` | no |
| <a name="input_post_userdata"></a> [post\_userdata](#input\_post\_userdata) | Custom userdata to run immediately after rke2 node attempts to join cluster | `string` | `""` | no |
| <a name="input_pre_userdata"></a> [pre\_userdata](#input\_pre\_userdata) | Custom userdata to run immediately before rke2 node attempts to join cluster, after required rke2, dependencies are installed | `string` | `""` | no |
| <a name="input_rke2_config"></a> [rke2\_config](#input\_rke2\_config) | Additional configuration for config.yaml | `string` | `""` | no |
| <a name="input_rke2_version"></a> [rke2\_version](#input\_rke2\_version) | Version to use for RKE2 server nodes | `string` | `"v1.24.4+rke2r1"` | no |
| <a name="input_server_url"></a> [server\_url](#input\_server\_url) | url of the controlplane | `string` | n/a | yes |
| <a name="input_servers"></a> [servers](#input\_servers) | Number of servers to create | `number` | `3` | no |
| <a name="input_spot"></a> [spot](#input\_spot) | Toggle spot requests for server pool | `bool` | `false` | no |
| <a name="input_ssh_authorized_keys"></a> [ssh\_authorized\_keys](#input\_ssh\_authorized\_keys) | Server pool list of public keys to add as authorized ssh keys | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs to create resources in | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to add to all resources created | `map(string)` | `{}` | no |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Enables/disables generation of a unique suffix to cluster name | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to create resources in | `string` | n/a | yes |
| <a name="input_wait_for_capacity_timeout"></a> [wait\_for\_capacity\_timeout](#input\_wait\_for\_capacity\_timeout) | How long Terraform should wait for ASG instances to be healthy before timing out. | `string` | `"10m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cidr"></a> [cidr](#output\_cidr) | cidr of the vpc |
| <a name="output_cluster_data"></a> [cluster\_data](#output\_cluster\_data) | Map of cluster data required by agent pools for joining cluster, do not modify this |
| <a name="output_cluster_hosted_zone_id"></a> [cluster\_hosted\_zone\_id](#output\_cluster\_hosted\_zone\_id) | route 53 hosted zone id |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the rke2 cluster |
| <a name="output_cluster_sg"></a> [cluster\_sg](#output\_cluster\_sg) | Security group shared by cluster nodes, this is different than nodepool security groups |
| <a name="output_domain"></a> [domain](#output\_domain) | base domain to use when creating subdomain for the cluster load balancer |
| <a name="output_iam_instance_profile"></a> [iam\_instance\_profile](#output\_iam\_instance\_profile) | IAM instance profile attached to server nodes |
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | IAM role of server nodes |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM role arn of server nodes |
| <a name="output_kubeconfig_bucket"></a> [kubeconfig\_bucket](#output\_kubeconfig\_bucket) | name of the bucket hostingn the kubeconfig |
| <a name="output_kubeconfig_filename"></a> [kubeconfig\_filename](#output\_kubeconfig\_filename) | filename of the kubeconfig file |
| <a name="output_kubeconfig_path"></a> [kubeconfig\_path](#output\_kubeconfig\_path) | path to the kubeconfig file in s3 |
| <a name="output_server_nodepool_arn"></a> [server\_nodepool\_arn](#output\_server\_nodepool\_arn) | arn of the autoscaler |
| <a name="output_server_nodepool_id"></a> [server\_nodepool\_id](#output\_server\_nodepool\_id) | id of the nodepool used in the autoscaler |
| <a name="output_server_nodepool_name"></a> [server\_nodepool\_name](#output\_server\_nodepool\_name) | name of the nodepool used in the autoscaler |
| <a name="output_server_sg"></a> [server\_sg](#output\_server\_sg) | security group for servers |
| <a name="output_server_url"></a> [server\_url](#output\_server\_url) | url of the control plane load balancer |
<!-- END_TF_DOCS -->