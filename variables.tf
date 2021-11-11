# argocd

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster"
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
}

# Helm

variable "helm_create_namespace" {
  type        = bool
  default     = true
  description = "Create the namespace if it does not yet exist"
}

variable "helm_chart_name" {
  type        = string
  default     = "gitlab-runner"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "0.34.0"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "gitlab-runner"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://charts.gitlab.io"
  description = "Helm repository"
}

variable "helm_wait" {
  type        = bool
  default     = true
  description = "Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout. Defaults to true."
}

variable "helm_timeout" {
  type        = number
  default     = 300
  description = "Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to 300 seconds."
}

variable "helm_cleanup_on_fail" {
  type        = bool
  default     = false
  description = "Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to false."
}

variable "helm_atomic" {
  type        = bool
  default     = false
  description = "If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to false."
}

# K8s

variable "k8s_namespace" {
  type        = string
  default     = "argo"
  description = "The K8s namespace in which the ingress-nginx has been created"
}

variable "k8s_rbac_create" {
  type        = bool
  default     = true
  description = "Whether to create and use RBAC resources"
}

variable "k8s_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create Service Account"
}

variable "k8s_irsa_role_name_prefix" {
  type        = string
  default     = "gitlab-runner-irsa"
  description = "The IRSA role name prefix for gitlab_runner"
}

variable "k8s_irsa_additional_policies" {
  type        = list(string)
  default     = []
  description = "Additional policies arn to be attached to created k8s_role"
}

variable "k8s_role_arn" {
  default     = ""
  description = "Whether to create and use default role or use existing role. Useful for a variety of use cases, such as cross account access. Default (empty string) use default generted role."
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/argo/argo-cd"
}

variable "values" {
  type        = string
  default     = ""
  description = "Additional yaml encoded values which will be passed to the Helm chart."
}

variable "gitlab_url" {
  type        = string
  default     = "https://gitlab.com/"
  description = "Gitlab URL"
}

variable "runner_registration_token" {
  type        = string
  default     = ""
  description = "The Registration Token for adding new Runners to the GitLab Server. This must be retrieved from your GitLab Instance"
}

variable "runner_token" {
  type        = string
  default     = ""
  description = "The Runner Token for adding new Runners to the GitLab Server. This must be retrieved from your GitLab Instance. It is token of already registered runner."
}

variable "runner_secret" {
  type        = string
  default     = ""
  description = "Kubernetes secret resource for gitlab runner sensitive data such as gitlab_token or runner_token"
}

variable "argo_application_enabled" {
  type        = bool
  default     = false
  description = "If set to true, the module will be deployed as ArgoCD application, otherwise it will be deployed as a Helm release"
}

variable "argo_application_use_helm" {
  type        = bool
  default     = false
  description = "If set to true, the ArgoCD Application manifest will be deployed using Kubernetes provider as a Helm release. Otherwise it'll be deployed as a Kubernetes manifest. See Readme for more info"
}

variable "argo_application_values" {
  default     = ""
  description = "Value overrides to use when deploying argo application object with helm"
}

variable "argo_destionation_server" {
  type        = string
  default     = "https://kubernetes.default.svc"
  description = "Destination server for ArgoCD Application"
}

variable "argo_project" {
  type        = string
  default     = "default"
  description = "ArgoCD Application project"
}

variable "argo_info" {
  default = [{
    "name"  = "terraform"
    "value" = "true"
  }]
  description = "ArgoCD info manifest parameter"
}

variable "argo_sync_policy" {
  description = "ArgoCD syncPolicy manifest parameter"
  default     = {}
}
