# Gitlab runner Terraform module

[![labyrinth labs logo](ll-logo.png)](https://lablabs.io/)

We help companies build, run, deploy and scale software and infrastructure by embracing the right technologies and principles. Check out our website at https://lablabs.io/

---

![Terraform validation](https://github.com/lablabs/terraform-aws-eks-node-problem-detector/workflows/Terraform%20validation/badge.svg?branch=main)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-success?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

## Description

A terraform module to deploy gitlab runner.

This module deploys ArgoCD in two different ways:
1. A helm release
2. ArgoCD Application CRD

When `argo_application_enabled` variable is set to true, gitlab runner is deployed as ArgoCD Application resource

## Related Projects

Check out these related projects.
- [terraform-helm-argocd](https://github.com/lablabs/terraform-helm-argocd)
- [terraform-helm-argo-rollouts](https://github.com/lablabs/terraform-helm-argo-rollouts)
- [terraform-aws-eks-metrics-server](https://github.com/lablabs/terraform-aws-eks-metrics-server)
- [terraform-aws-eks-cluster-autoscaler](https://github.com/lablabs/terraform-aws-eks-cluster-autoscaler)
- [terraform-aws-eks-external-dns](https://github.com/lablabs/terraform-aws-eks-external-dns)
- [terraform-aws-vector-agent-log](https://github.com/lablabs/terraform-aws-eks-vector-agent-log)
- [terraform-aws-eks-ingress-nginx](https://github.com/lablabs/terraform-aws-eks-ingress-nginx)
- [terraform-aws-eks-prometheus-node-exporter](https://github.com/lablabs/terraform-aws-eks-prometheus-node-exporter)
- [terraform-aws-eks-kube-state-metrics](https://github.com/lablabs/terraform-aws-eks-kube-state-metrics)
- [terraform-aws-eks-node-problem-detector](https://github.com/lablabs/terraform-aws-eks-node-problem-detector)
- [terraform-aws-eks-cert-manager](https://github.com/lablabs/terraform-aws-eks-cert-manager)
- [terraform-aws-eks-load-balancer-controller](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller)


## Examples

See [Basic example](examples/basic/README.md) for further information.

## Potential issues with running terraform plan

When deploying with ArgoCD application, Kubernetes terraform provider requires access to Kubernetes cluster API during plan time. This introduces potential issue when you want to deploy the cluster with this addon at the same time, during the same Terraform run.

To overcome this issue, the module deploys the ArgoCD application object using the Helm provider, which does not require API access during plan. If you want to deploy the application using this workaround, you can set the `argo_application_use_helm` variable to `true`.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.4.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.12.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.gitlab_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.gitlab_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.argocd_application](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.self](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.self](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [aws_iam_policy_document.gitlab_runner_irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [utils_deep_merge_yaml.argo_application_values](https://registry.terraform.io/providers/cloudposse/utils/latest/docs/data-sources/deep_merge_yaml) | data source |
| [utils_deep_merge_yaml.values](https://registry.terraform.io/providers/cloudposse/utils/latest/docs/data-sources/deep_merge_yaml) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_identity_oidc_issuer"></a> [cluster\_identity\_oidc\_issuer](#input\_cluster\_identity\_oidc\_issuer) | The OIDC Identity issuer for the cluster | `string` | n/a | yes |
| <a name="input_cluster_identity_oidc_issuer_arn"></a> [cluster\_identity\_oidc\_issuer\_arn](#input\_cluster\_identity\_oidc\_issuer\_arn) | The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account | `string` | n/a | yes |
| <a name="input_argo_application_enabled"></a> [argo\_application\_enabled](#input\_argo\_application\_enabled) | If set to true, the module will be deployed as ArgoCD application, otherwise it will be deployed as a Helm release | `bool` | `false` | no |
| <a name="input_argo_application_use_helm"></a> [argo\_application\_use\_helm](#input\_argo\_application\_use\_helm) | If set to true, the ArgoCD Application manifest will be deployed using Kubernetes provider as a Helm release. Otherwise it'll be deployed as a Kubernetes manifest. See Readme for more info | `bool` | `false` | no |
| <a name="input_argo_application_values"></a> [argo\_application\_values](#input\_argo\_application\_values) | Value overrides to use when deploying argo application object with helm | `string` | `""` | no |
| <a name="input_argo_destionation_server"></a> [argo\_destionation\_server](#input\_argo\_destionation\_server) | Destination server for ArgoCD Application | `string` | `"https://kubernetes.default.svc"` | no |
| <a name="input_argo_info"></a> [argo\_info](#input\_argo\_info) | ArgoCD info manifest parameter | `list` | <pre>[<br>  {<br>    "name": "terraform",<br>    "value": "true"<br>  }<br>]</pre> | no |
| <a name="input_argo_namespace"></a> [argo\_namespace](#input\_argo\_namespace) | Namespace to deploy ArgoCD application CRD to | `string` | `"argo"` | no |
| <a name="input_argo_project"></a> [argo\_project](#input\_argo\_project) | ArgoCD Application project | `string` | `"default"` | no |
| <a name="input_argo_sync_policy"></a> [argo\_sync\_policy](#input\_argo\_sync\_policy) | ArgoCD syncPolicy manifest parameter | `map` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Variable indicating whether deployment is enabled | `bool` | `true` | no |
| <a name="input_gitlab_url"></a> [gitlab\_url](#input\_gitlab\_url) | Gitlab URL | `string` | `"https://gitlab.com/"` | no |
| <a name="input_helm_atomic"></a> [helm\_atomic](#input\_helm\_atomic) | If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to false. | `bool` | `false` | no |
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | Helm chart name to be installed | `string` | `"gitlab-runner"` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Version of the Helm chart | `string` | `"0.34.0"` | no |
| <a name="input_helm_cleanup_on_fail"></a> [helm\_cleanup\_on\_fail](#input\_helm\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to false. | `bool` | `false` | no |
| <a name="input_helm_create_namespace"></a> [helm\_create\_namespace](#input\_helm\_create\_namespace) | Create the namespace if it does not yet exist | `bool` | `true` | no |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | Helm release name | `string` | `"gitlab-runner"` | no |
| <a name="input_helm_repo_url"></a> [helm\_repo\_url](#input\_helm\_repo\_url) | Helm repository | `string` | `"https://charts.gitlab.io"` | no |
| <a name="input_helm_timeout"></a> [helm\_timeout](#input\_helm\_timeout) | Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to 300 seconds. | `number` | `300` | no |
| <a name="input_helm_wait"></a> [helm\_wait](#input\_helm\_wait) | Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout. Defaults to true. | `bool` | `true` | no |
| <a name="input_k8s_irsa_additional_policies"></a> [k8s\_irsa\_additional\_policies](#input\_k8s\_irsa\_additional\_policies) | Additional policies arn to be attached to created k8s\_role | `list(string)` | `[]` | no |
| <a name="input_k8s_irsa_additional_policies_count"></a> [k8s\_irsa\_additional\_policies\_count](#input\_k8s\_irsa\_additional\_policies\_count) | Additional policies count to be attached to created k8s\_role | `number` | `0` | no |
| <a name="input_k8s_irsa_role_name_prefix"></a> [k8s\_irsa\_role\_name\_prefix](#input\_k8s\_irsa\_role\_name\_prefix) | The IRSA role name prefix for gitlab\_runner | `string` | `"gitlab-runner-irsa"` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | The K8s namespace in which the gitlab-runner has been created | `string` | `"gitlab-runner"` | no |
| <a name="input_k8s_rbac_create"></a> [k8s\_rbac\_create](#input\_k8s\_rbac\_create) | Whether to create and use RBAC resources | `bool` | `true` | no |
| <a name="input_k8s_role_arn"></a> [k8s\_role\_arn](#input\_k8s\_role\_arn) | Whether to create and use default role or use existing role. Useful for a variety of use cases, such as cross account access. Default (empty string) use default generted role. | `string` | `""` | no |
| <a name="input_k8s_service_account_create"></a> [k8s\_service\_account\_create](#input\_k8s\_service\_account\_create) | Whether to create Service Account | `bool` | `true` | no |
| <a name="input_runner_registration_token"></a> [runner\_registration\_token](#input\_runner\_registration\_token) | The Registration Token for adding new Runners to the GitLab Server. This must be retrieved from your GitLab Instance | `string` | `""` | no |
| <a name="input_runner_secret"></a> [runner\_secret](#input\_runner\_secret) | Kubernetes secret resource for gitlab runner sensitive data such as gitlab\_token or runner\_token | `string` | `""` | no |
| <a name="input_runner_token"></a> [runner\_token](#input\_runner\_token) | The Runner Token for adding new Runners to the GitLab Server. This must be retrieved from your GitLab Instance. It is token of already registered runner. | `string` | `""` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/argo/argo-cd | `map(any)` | `{}` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional yaml encoded values which will be passed to the Helm chart. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_release_application_metadata"></a> [helm\_release\_application\_metadata](#output\_helm\_release\_application\_metadata) | Argo application helm release attributes |
| <a name="output_helm_release_metadata"></a> [helm\_release\_metadata](#output\_helm\_release\_metadata) | Helm release attributes |
| <a name="output_iam_role_attributes"></a> [iam\_role\_attributes](#output\_iam\_role\_attributes) | Gitlab-runner IAM role atributes |
| <a name="output_kubernetes_application_attributes"></a> [kubernetes\_application\_attributes](#output\_kubernetes\_application\_attributes) | Argo kubernetes manifest attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing and reporting issues

Feel free to create an issue in this repository if you have questions, suggestions or feature requests.

### Validation, linters and pull-requests

We want to provide high quality code and modules. For this reason we are using
several [pre-commit hooks](.pre-commit-config.yaml) and
[GitHub Actions workflow](.github/workflows/main.yml). A pull-request to the
master branch will trigger these validations and lints automatically. Please
check your code before you will create pull-requests. See
[pre-commit documentation](https://pre-commit.com/) and
[GitHub Actions documentation](https://docs.github.com/en/actions) for further
details.


## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
