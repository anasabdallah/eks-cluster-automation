module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment =  "${var.env}"
    Project     =  "${var.project}"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "${var.env}-${var.project}-worker-group"
      instance_type                 = "${var.instance_type}"
      asg_desired_capacity          = var.asg_desired_capacity
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }
  ]
}

variable "asg_desired_capacity" {
  type = number
}
variable "instance_type" {
  type = string
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
