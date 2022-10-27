locals {
  values_default = yamlencode({
    gitlabUrl               = var.gitlab_url
    runnerRegistrationToken = var.runner_registration_token
    rbac = merge(
      {
        create             = var.rbac_create
        serviceAccountName = var.service_account_name
      },
      local.irsa_role_create ? {
        serviceAccountAnnotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.this[0].arn
        }
      } : {}
    )
    metrics = {
      enabled = true
    }
    runners = {
      privileged         = false
      serviceAccountName = var.service_account_name
    }
  })
}

data "utils_deep_merge_yaml" "values" {
  count = var.enabled ? 1 : 0
  input = compact([
    local.values_default,
    var.values
  ])
}
