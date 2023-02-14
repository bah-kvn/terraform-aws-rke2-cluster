
module "iam" {
  count                = var.iam_instance_profile == "" ? 1 : 0
  source               = "git::https://repo1.dso.mil/platform-one/distros/rancher-federal/rke2/rke2-aws-terraform.git//modules/policies?ref=v2.1.0"
  name                 = "${local.uname}-rke2-server"
  permissions_boundary = var.iam_permissions_boundary
  tags                 = merge({}, local.default_tags, var.tags)
}

resource "aws_iam_role_policy" "aws_required" {
  count  = var.iam_instance_profile == "" ? 1 : 0
  name   = "${local.uname}-rke2-server-aws-introspect"
  role   = module.iam[count.index].role
  policy = data.aws_iam_policy_document.aws_required[count.index].json
}

resource "aws_iam_role_policy" "aws_ccm" {
  count  = var.iam_instance_profile == "" && var.enable_ccm ? 1 : 0
  name   = "${local.uname}-rke2-server-aws-ccm"
  role   = module.iam[count.index].role
  policy = data.aws_iam_policy_document.aws_ccm[count.index].json
}

resource "aws_iam_role_policy" "get_token" {
  count  = var.iam_instance_profile == "" ? 1 : 0
  name   = "${local.uname}-rke2-server-get-token"
  role   = module.iam[count.index].role
  policy = module.statestore.token.policy_document
}

resource "aws_iam_role_policy" "put_kubeconfig" {
  count  = var.iam_instance_profile == "" ? 1 : 0
  name   = "${local.uname}-rke2-server-put-kubeconfig"
  role   = module.iam[count.index].role
  policy = module.statestore.kubeconfig_put_policy
}

resource "aws_security_group" "cluster" {
  count       = var.nodepool_security_group_id == "" ? 1 : 0
  name        = "${local.uname}-rke2-cluster"
  description = "Shared ${local.uname} cluster security group"
  vpc_id      = var.vpc_id
  tags        = merge({ "shared" = "true", }, local.default_tags, var.tags)
}

resource "aws_security_group_rule" "controlplane_lb" {
  count             = var.nodepool_security_group_id == "" ? 1 : 0
  description       = "Allow public Network Load Balancer traffic to trusted cidrs"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.cluster[count.index].id
  type              = "ingress"
  cidr_blocks       = var.lb_addresses
}

resource "aws_security_group_rule" "controlplane_allowed_cidrs" {
  count             = var.nodepool_security_group_id == "" ? 1 : 0
  description       = "Allow all inbound traffic between trusted cidrs"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.cluster[count.index].id
  type              = "ingress"
  cidr_blocks       = var.controlplane_allowed_cidrs
}

resource "aws_security_group_rule" "cluster_shared" {
  count             = var.nodepool_security_group_id == "" ? 1 : 0
  description       = "Allow all inbound traffic between ${local.uname} cluster nodes"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.cluster[count.index].id
  type              = "ingress"
  self              = true
}

resource "aws_security_group_rule" "cluster_egress" {
  count             = var.nodepool_security_group_id == "" ? 1 : 0
  description       = "Allow all outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.cluster[count.index].id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
}

# Server Security Group
resource "aws_security_group" "server" {
  count       = var.nodepool_security_group_id == "" ? 1 : 0
  name        = "${local.uname}-rke2-server"
  vpc_id      = var.vpc_id
  description = "${local.uname} rke2 server node pool"
  tags        = merge(local.default_tags, var.tags)
}

resource "aws_security_group_rule" "server_lb" {
  count             = var.nodepool_security_group_id == "" ? 1 : 0
  description       = "Allow public Network Load Balancer traffic to controlplane nodes"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.server[count.index].id
  type              = "ingress"
  cidr_blocks       = var.lb_addresses
}

resource "aws_security_group_rule" "server_cp" {
  count                    = var.nodepool_security_group_id == "" ? 1 : 0
  description              = "Allow traffic on port 6443"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.server[count.index].id
  type                     = "ingress"
  source_security_group_id = aws_security_group.cluster[count.index].id
}

resource "aws_security_group_rule" "server_cp_supervisor" {
  count                    = var.nodepool_security_group_id == "" ? 1 : 0
  description              = "Allow traffic on port 9345"
  from_port                = 9345
  to_port                  = 9345
  protocol                 = "tcp"
  security_group_id        = aws_security_group.server[count.index].id
  type                     = "ingress"
  source_security_group_id = aws_security_group.cluster[count.index].id
}

