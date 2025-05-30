/**
 * # AWS EKS GitLab Runner Terraform module
 *
 * A Terraform module to deploy the [GitLab Runner](https://docs.gitlab.com/runner/) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-gitlab-runner/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-gitlab-runner/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-gitlab-runner/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-gitlab-runner/actions/workflows/pre-commit.yml)
 */
locals {
  addon = {
    name = "gitlab-runner"

    helm_chart_version = "0.73.3"
    helm_repo_url      = "https://charts.gitlab.io"
  }

  addon_irsa = {
    (local.addon.name) = {}
  }

  addon_values = yamlencode({
    gitlabUrl               = var.gitlab_url
    runnerRegistrationToken = var.runner_registration_token

    rbac = {
      create = module.addon-irsa[local.addon.name].rbac_create
    }

    serviceAccount = {
      create = module.addon-irsa[local.addon.name].service_account_create
      name   = module.addon-irsa[local.addon.name].service_account_name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }

    metrics = {
      enabled = true
    }
  })

  addon_depends_on = []
}
