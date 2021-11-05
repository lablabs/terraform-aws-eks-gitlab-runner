locals {
  k8s_assume_role = length(var.k8s_assume_role_arn) > 0 ? true : false
}

data "aws_iam_policy_document" "gitlab_runner" {
  count = local.k8s_irsa_role_create && var.enabled && !local.k8s_assume_role ? 1 : 0
  statement {
    sid = "VisualEditor0"

    effect = "Allow"

    actions = [
      "ecr:PutImageTagMutability",
      "ecr:StartImageScan",
      "ecr:ListTagsForResource",
      "ecr:UploadLayerPart",
      "ecr:BatchDeleteImage",
      "ecr:ListImages",
      "ecr:PutRegistryPolicy",
      "ecr:DeleteRepository",
      "ecr:CompleteLayerUpload",
      "ecr:TagResource",
      "ecr:DescribeRepositories",
      "ecr:DeleteRepositoryPolicy",
      "ecr:BatchCheckLayerAvailability",
      "ecr:ReplicateImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetRegistryPolicy",
      "ecr:PutLifecyclePolicy",
      "ecr:DescribeImageScanFindings",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:CreateRepository",
      "ecr:DescribeRegistry",
      "ecr:PutImageScanningConfiguration",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:DeleteLifecyclePolicy",
      "ecr:PutImage",
      "ecr:UntagResource",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:StartLifecyclePolicyPreview",
      "ecr:DeleteRegistryPolicy",
      "ecr:InitiateLayerUpload",
      "ecr:GetRepositoryPolicy",
      "ecr:PutReplicationConfiguration"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "gitlab_runner_assume" {
  count = local.k8s_irsa_role_create && var.enabled && local.k8s_assume_role ? 1 : 0
  statement {
    sid = "AllowAssumegitlab_runnerRole"

    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      var.k8s_assume_role_arn
    ]
  }
}

resource "aws_iam_policy" "gitlab_runner" {
  count = local.k8s_irsa_role_create && var.enabled ? 1 : 0

  name        = "${var.k8s_irsa_role_name_prefix}-${var.helm_chart_name}-gitlab_runner"
  path        = "/"
  description = "Policy for gitlab_runner able to work with ECR"
  policy      = local.k8s_assume_role ? data.aws_iam_policy_document.gitlab_runner_assume[0].json : data.aws_iam_policy_document.gitlab_runner[0].json
}

resource "aws_iam_role_policy_attachment" "gitlab_runner" {
  count = local.k8s_irsa_role_create && var.enabled ? 1 : 0

  role       = aws_iam_role.gitlab_runner[0].name
  policy_arn = aws_iam_policy.gitlab_runner[0].arn
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