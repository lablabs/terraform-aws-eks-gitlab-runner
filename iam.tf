resource "aws_iam_role_policy_attachment" "gitlab_runner" {
  count = var.k8s_irsa_additional_policies_count

  role       = aws_iam_role.gitlab_runner[0].name
  policy_arn = var.k8s_irsa_additional_policies[count.index]
}

data "aws_iam_policy_document" "gitlab_runner_irsa" {
  count = local.k8s_irsa_role_create ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.k8s_namespace}:${local.k8s_service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "gitlab_runner" {
  count = local.k8s_irsa_role_create ? 1 : 0

  name               = "${var.k8s_irsa_role_name_prefix}-${var.helm_chart_name}"
  assume_role_policy = data.aws_iam_policy_document.gitlab_runner_irsa[0].json
}
