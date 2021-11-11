output "helm_release_metadata" {
  description = "Helm release attributes"
  value       = try(helm_release.self[0].metadata, {})
}

output "helm_release_application_metadata" {
  description = "Argo application helm release attributes"
  value       = try(helm_release.argocd_application[0].metadata, {})
}

output "kubernetes_application_attributes" {
  description = "Argo kubernetes manifest attributes"
  value       = try(kubernetes_manifest.self, {})
}

output "iam_role_attributes" {
  description = "Gitlab-runner IAM role atributes"
  value       = try(aws_iam_role.gitlab_runner[0], {})
}
