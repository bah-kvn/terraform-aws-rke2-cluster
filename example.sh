#!/bin/bash
[ -d ".terraform" ] || terraform init # only require to run once.
export TF_VAR_cluster_name="rke2"
export TF_VAR_cluster_aws_region="us-east-1"
export TF_VAR_controleplane_internal=false
export TF_VAR_domain="$DOMAIN"
export TF_VAR_enable_ccm=true
export TF_VAR_iam_instance_profile="$SERVER_INSTANCE_PROFILE"
export TF_VAR_agent_instance_profile="$AGENT_INSTANCE_PROFILE"
export TF_VAR_kubeconfig_path="/usr/local/git/terraform-aws-rke2-cluster/rke2.yaml"
export TF_VAR_iam_instance_profile="$SERVER_INSTANCE_PROFILE"
export TF_VAR_rke2_version="v1.25.4+rke2r1"
export TF_VAR_servers=3
export TF_VAR_ssh_authorized_keys="[\"$PUBKEY\"]"
export TF_VAR_subnets="$SUBNETS"
export TF_VAR_user_access_cidr="[\"$(curl -s checkip.amazonaws.com)/32\"]"
export TF_VAR_vpc_id="$VPC_ID"
export log=/tmp/tf-deploy.log
export TF_LOG_PATH=$log
export TF_LOG=DEBUG

terraform plan && terraform apply -auto-approve | tee $log

