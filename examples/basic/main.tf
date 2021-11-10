module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.6.0"

  name               = "gitlab-runner-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["eu-central-1a", "eu-central-1b"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
}

module "eks_cluster" {
  source  = "cloudposse/eks-cluster/aws"
  version = "0.43.2"

  region     = "eu-central-1"
  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id
  name       = "gitlab-runner"
}

module "eks_node_group" {
  source  = "cloudposse/eks-node-group/aws"
  version = "0.25.0"

  cluster_name   = "gitlab-runner"
  instance_types = ["t3.medium"]
  subnet_ids     = module.vpc.public_subnets
  min_size       = 1
  desired_size   = 1
  max_size       = 2
  depends_on     = [module.eks_cluster.kubernetes_config_map_id]
}

module "gitlab-runner" {
  source = "../../"

  enabled = true


  cluster_name                     = module.eks_cluster.eks_cluster_id
  cluster_identity_oidc_issuer     = module.eks_cluster.eks_cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn

  settings = {
    # Examples:

    ## controller:
    ##   image:
    ##     tag: "v0.41.2"
    #
    # "controller.image.tag" = "v0.41.2"

    ## extraEnv:
    ## - name: var1
    ##   value: value1
    ## - name: var2
    ##   value: value2
    #
    ## "extraEnv[0].name"  = "var1"
    ## "extraEnv[0].value" = "value1"
    ## "extraEnv[1].name"  = "var2"
    ## "extraEnv[1].value" = "value2"

    ## extraEnv:
    ## - name: var3
    ##   valueFrom:
    ##     secretKeyRef:
    ##       name: existing-secret
    ##       key: varname3-key

    # "extraEnv[2].name" = "var3"
    # "extraEnv[2].valueFrom.secretKeyRef.name" = "existing-secret"
    # "extraEnv[2].valueFrom.secretKeyRef.key" = "varname3-key"
  }

  values = <<-EOF
    k8s_irsa_additional_policies : []
      k8s_role_arn : ""
      values = yamlencode({
        "runners" : {
          "tags" : "test-tag1, test-tag2"
        }
      })
  EOF
}
