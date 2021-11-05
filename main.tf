locals {
  k8s_irsa_role_create      = var.enabled && var.k8s_rbac_create && var.k8s_service_account_create && var.k8s_irsa_role_create
  k8s_service_account_name  = "${var.helm_chart_name}-${var.helm_release_name}"
  values_default = yamlencode({
    "gitlabUrl" : var.gitlab_url
    "runnerRegistrationToken" : var.gitlab_token
    "rbac" : {
      "create" : var.k8s_rbac_create
      "rules" : []
      # - resources: ["pods", "secrets"]
      #   verbs: ["get", "list", "watch", "create", "patch", "delete"]
      # - apiGroups: [""]
      #   resources: ["pods/exec"]
      #   verbs: ["create", "patch", "delete"]
      "clusterWideAccess" : "false"
      "serviceAccountName" : local.k8s_service_account_name
      "serviceAccountAnnotations" : {
        "eks.amazonaws.com/role-arn" : local.k8s_irsa_role_create ? aws_iam_role.gitlab_runner[0].arn : var.k8s_assume_role_arn
      }
    }
    "metrics" : {
      "enabled" : "true"
    }
    "runners" : {
      "config" : <<-EOF
        [[runners]]
          [runners.kubernetes]
            namespace = "{{.Release.Namespace}}"
            image = "ubuntu:16.04"
      EOF
      "privileged" : "false"
      "serviceAccountName" : local.k8s_service_account_name
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

resource "helm_release" "self" {
  count            = var.enabled && !var.argo_application_enabled ? 1 : 0
  repository       = var.helm_repo_url
  chart            = var.helm_chart_name
  version          = var.helm_chart_version
  create_namespace = var.helm_create_namespace
  namespace        = var.k8s_namespace
  name             = var.helm_release_name

  values = [
    data.utils_deep_merge_yaml.values[0].output
  ]

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
