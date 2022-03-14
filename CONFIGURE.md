<div style="text-align: center; font-weight: bolder; color: red; font-size: 16pt;"><i>Developed by Riva Solutions Inc 2022.  Authorized Use Only</i></div><br />

# OpenCloudCX Project Configuration

## AWS S3 State Bucket

If remote state storge is desired, follow the instructions in this section. If not, skip to **Project Variables**. This file is not required for successful environment generation. _NOTE: Terraform Cloud handles environment state as a native capability. If Terraform cloud is being used, skip down to the **Secrets** section._

OpenCloudCX can use Terraform state buckets to store all infrastructure snapshot information (e.g., S3 buckets, VPC, EC2, EKS). State buckets allow for teams to have a centralized souce of truth for the infrastructure. Per AWS S3 requirements, this bucket name needs to be globally unique. This bucket is not created automatically and needs to be in place before the terraform project is initialized.

Follows [these]() instructions to create a unique bucket in the account where OpenCloudCX is going to be installed. A good convention for this project is to create and use `opencloucx-state-bucket-####` and replace `####` with the last 4 digits of the AWS account number.

Once the bucket has been created, copy `state.tf.example` and rename the copy (not the original) to `state.tf`. Update the variables and save.

```bash
  backend "s3" {
    key    =     "[terraform-state-filename]"
    bucket =     "[bucket name]"
    region =     "[region]"
    access_key = "[aws access key]"
    secret_key = "[aws secret key]"
  }
```

Update the variables within the state file

| Variable   | Explanation                         |
| ---------- | ----------------------------------- |
| key        | Filename of state file in s3 bucket |
| bucket     | S3 bucket used to store state       |
| region     | AWS region for file storage         |
| access_key | AWS Access Key                      |
| secret_key | AWS Secret Access Key               |

NOTE: If the default AWS profile is being used (from `~/.aws/credentials`) or the credentials are being passed through environment variables, the `access_key` and `secret_key` entries are not used. If you get the following error message, check your `access_key` and `secret_key`.

```
Initializing the backend...
╷
│ Error: error configuring S3 Backend: no valid credential sources for S3 Backend found.
│
│ Please see https://www.terraform.io/docs/language/settings/backends/s3.html
│ for more information about providing credentials.
│
│ Error: NoCredentialProviders: no valid providers in chain. Deprecated.
│       For verbose messaging see aws.Config.CredentialsChainVerboseErrors
```

## Variables

Create copies of `variables.example.tfvars` and `secrets.example.tfvars` files and name them `variables.auto.tfvars` and `secrets.auto.tfvars` respectively. If other filenames needs to be used, Terraform automatically loads a number of variable definitions files if named the following way:

- Files named exactly `terraform.tfvars` or `terraform.tfvars.json`
- Any files with names ending in `.auto.tfvars` or `.auto.tfvars.json`

Update the variables within each file for any desired configuration changes

## `secrets.auto.tfvars`

| Variable                               | Explanation                                                                                                                                                       |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `access_key`                           | AWS Access Key                                                                                                                                                    |
| `secret_key`                           | AWS Secret Access Key                                                                                                                                             |
| `kubernetes_secret_dockerhub_password` | Dockerhub password for posting images. <p style="color:orange;"><i>This entry can be removed or commented out if no dockerhub account is being configured</i></p> |

## `variables.auto.tfvars`

<table width=100%>
<tr>
  <th width="15%" style="font-weight:bolder;">Variable</th>
  <th width="35%" style="font-weight:bolder;">Explanation</th>
  <th width="50%" style="font-weight:bolder;">Example</th>
</tr>
<tr>
  <td><code>eks_map_roles</code></td>
  <td>Additional IAM roles to add to the aws-auth configmap. This entry can be removed or commented out if no extra roles need to be added.
  </td>
  <td>
  
  <i>Defining Extra Roles</i>
```bash
eks_map_roles = [{
  groups   = ["system:masters"]
  rolearn  = "arn:aws:iam::<account_number>:role/<role name>"
  username = "<username>"
}]  
```
<i>No extra roles</i>
```bash
eks_map_roles = []
```

  </td>
</tr>
<tr>
  <td><code>eks_map_users</code></td>
  <td>Additional IAM users to add to the aws-auth configmap. This entry can be removed or commented out if no extra users need to be added.</td>
  <td>
  
<i>Defining Extra Users</i>
```bash
eks_map_users = [{
  groups   = ["system:masters"]
  userarn  = "arn:aws:iam::<account number>:user/<user name>"
  username = "<username>"
}]  
```
<i>No extra users</i>
```bash
eks_map_users = []
```

  </td>
</tr>

<tr>
  <td><code>worker_groups</code></td>
  <td>Definition of worker groups in the aws eks cluster. This entry can be removed or commented out if no changes to the default configuration are needed.</td>
  <td>

```bash
worker_groups = [
  {
    name                 = "worker-group-1"
    instance_type        = "m5.xlarge"
    asg_desired_capacity = 3
  }
]
```

  </td>
</tr>

<tr>
  <td><code>dns_zone</code></td>
  <td>To experience the full impact of an OpenCloudCX installation, a valid, publicly accessible DNS zone needs to be supplied within the configuration. The default DNS Zone can be used for initial prototyping with appropriate local hosts file manipulation or kubectl port forwarding.
  <br /><br />
  NOTE: The referenced DNS zone in this configuation must already exist in the target account. Refer to <a href="https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html">these</a> instructions to create the zone. The following error message will be shown if the configuration is incorrect
  
  ```bash
  Error: no matching Route53Zone found
│
│   with module.opencloudcx-aws-dev.data.aws_route53_zone.vpc,
│   on .terraform/modules/opencloudcx-aws-dev/route53.tf line 1, in data "aws_route53_zone" "vpc":
│    1: data "aws_route53_zone" "vpc" {
  ```
  
  </td>
  <td>

```bash
dns_zone = "spinnaker.internal"
```

</td>
</tr>

<tr>
<td><code>kubernetes_dockerhub_secret_name</code></td>
<td>Named reference to the dockerhub secrets used when publishing to dockerhub. <p style="color:orange;"><i>This entry can be removed or commented out if no dockerhub account is being configured.</i></p></td>
<td>

```bash
kubernetes_dockerhub_secret_name = "my-dockerhub"
```

</td>
</tr>

<tr>
<td><code>kubernetes_secret_dockerhub_username</code></td>
<td>Username to use when authenticating to dockerhub. <p style="color:orange;"><i>This entry can be removed or commented out if no dockerhub account is being configured.</i></p></td>
<td>

```bash
kubernetes_secret_dockerhub_username = "username"
```

</td>
</tr>

<tr>
<td><code>kubernetes_secret_dockerhub_email</code></td>
<td>Email address for configuration in dockerhub. <p style="color:orange;"><i>This entry can be removed or commented out if no dockerhub account is being configured.</i></p></td>
<td>

```bash
kubernetes_secret_dockerhub_email = "email@domain.com"
```

</td>
</tr>

</table>

# Modules

To include OpenCloudCX modules, refer to the individual plugin README page for instructions.

## Capability Modules

<table width="100%">

<tr style="font-size:16pt"><th colspan="3" width="50%">Current</th><th colspan="3" width="50%">Future</th></tr>
<tr><td><b>Name</b></td><td><b>Functionality</b></td><td><b>URL</b></td><td><b>Name</b></td><td><b>Functionality</b></td><td><b>URL</b></td></tr>

<tr>
  <td>module-code-server</td>
  <td>Code Server</td>
  <td><a href="https://github.com/OpenCloudCX/module-code-server">Github Link</a></td>
  <td>module-nexus</td>
  <td>Nexus</td>
  <td><a href="https://github.com/OpenCloudCX/module-nexus">Github Link</td>
</tr>

<tr>
  <td>module-drupal</td>
  <td>Drupal</td>
  <td><a href="https://github.com/OpenCloudCX/module-drupal">Github Link</a></td>
  <td></td>
  <td></td>
  <td></td>
</tr>

<tr>
  <td>module-postgresql</td>
  <td>PostgreSQL</td>
  <td><a href="https://github.com/OpenCloudCX/module-postgresql">Github Link</td>
  <td></td>
  <td></td>
  <td></td>
</tr>

<tr>
  <td>module-anchore</td>
  <td>Anchore Engine</td>
  <td><a href="https://github.com/OpenCloudCX/module-anchore">Github Link</td>
  <td></td>
  <td></td>
  <td></td>
</tr>

<tr>
  <td>module-sonarqube</td>
  <td>Sonarqube</td>
  <td><a href="https://github.com/OpenCloudCX/module-sonarqube">Github Link</td>
  <td></td>
  <td></td>
  <td></td>
</tr>

<tr>
  <td>module-mariadb</td>
  <td>MariaDB</td>
  <td><a href="https://github.com/OpenCloudCX/module-mariadb">Github Link</td>
  <td></td>
  <td></td>
  <td></td>
</tr>

<tr>
  <td>module-grafana-monitoring</td>
  <td>Grafana monitoring setup using Prometheus</td>
  <td><a href="https://github.com/OpenCloudCX/module-grafana-monitoring">Github Link</td>
  <td></td>
  <td></td>
  <td></td>
</tr>

</table>

<div style="text-align: center; font-weight: bolder; color: red; font-size: 16pt;"><i>Developed by Riva Solutions Inc 2022.  Authorized Use Only</i></div><br />
