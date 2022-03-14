<div style="text-align: center; font-weight: bolder; color: red; font-size: 16pt;"><i>Developed by RIVA Solutions Inc 2022.  Authorized Use Only</i></div><br />

# OpenCloudCX setup in AWS

# [Terraform Cloud](https://www.terraform.io/cloud) Setup

Using terraform cloud will allow for a collaborative workspace approach to all installations. Terraform cloud will manage all environment state natively.

# Account Creation

Navigate to [Terraform Cloud](https://www.terraform.io/cloud) and log in with existing credentials or create a new free account.

# Toolsets

## Required

| Toolset      | Links                                                                                                                                                                                               | Notes                                                                                                         |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| AWS&nbsp;CLI | [Instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) \|\| [Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) | This link provides information for getting started with version 2 of the AWS Command Line Interface (AWS CLI) |
| kubectl      | [Instructions](https://kubernetes.io/docs/tasks/tools/#kubectl)                                                                                                                                     | Allows commands to be executed against Kubernetes clusters                                                    |
| Git          | [Instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)                                                                                                                       | Need to run this command to avoid a CRLF issues: git config --global core.autocrlf input                      |

## Optional

| Toolset                           | Links                                                                      | Notes                                                                                                                |
| --------------------------------- | -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Windows Subsystem for Linux (WSL) | [Instructions](https://docs.microsoft.com/en-us/windows/wsl/install-win10) | This is a robust linux capability for Windows 10 and Windows 11. Linux instructions are written for Ubuntu 20.04 LTS |

# Workspace setup

After logging into terraform cloud, create a new workspace with the following options:

| Step                | Selections/Values                                                            | Notes                                                                                                                   |
| ------------------- | ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Choose Type         | Version control workflow                                                     |                                                                                                                         |
| Connect to VCS      | Github                                                                       | Do _NOT_ select "GitHub Enterprise" or "GitHub.com (Custom)                                                             |
| Choose a repository | _Select the bootstrap project for the appropriate environment configuration_ | This repository will contain the bootstrap configuration from the configuration instructions                            |
| Configure settings  | Workspace name.                                                              | If a specific target branch is used for this build, select `Advanced Options` and enter the branch name in `VSS Branch` |

## Variables

After workspace creation, select `Variables` and add the following entries

| Key        | Value                                     | Category  | Notes                                                                                                                                              |
| ---------- | ----------------------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| dns_zone   | _DNS zone for installation_               | terraform | To experience the full impact of an OpenCloudCX installation, a valid, publicly accessible DNS zone needs to be supplied within the configuration. |
| aws_region | AWS region for installation               | terraform | Installation region                                                                                                                                |
| access_key | Access key for the AWS account to be used | terraform | This account information is presented when the AWS IAM account is created or can be created within IAM/`Security credentials`                      |
| secret_key | Secret key for the AWS account to be used | terraform | This account information is presented when the AWS IAM account is created or can be created within IAM/`Security credentials`                      |

# Environment Creation

Select `Runs` and select `Start new plan` from the `Actions` menu.

# Environment Validation

Once a successful execution of the workspace has been achieved, run the apprioriate script to connect.

<table>
<tr><th style="font-size:14pt">Linux</th><th style="font-size:14pt">Windows</th></tr>
<tr><td>

```bash
$ connect.sh --profile <profile name>
```

</td><td>

```powershell
connect.ps1 -AwsProfile <profile name>
```

</td></tr>
</table>

Output from the above commands:
|Label|Description|
|---|---|
|Cluster name|Name of the Kubernetes cluster for OpenCloudCX. This name will always contain a 4-character randomized string at the end|
|Dashboard&nbsp;token|Token for use when authenticating to the Kubeternetes dashboard (see below)|
|Jenkins PW|Jenkins admin password|
|Grafana PW|Grafana admin password|

<!-- |CodeServer PW|Code Server admin password| -->

Execute following command to list the namespaces in the cluster

```bash
$ kubectl get namespaces -A

NAME                   STATUS   AGE
cert-manager           Active   10m
dashboard              Active   10m
default                Active   10m
develop                Active   10m
ingress-nginx          Active   10m
jenkins                Active   10m
kube-node-lease        Active   10m
kube-public            Active   10m
kube-system            Active   10m
opencloudcx            Active   10m
spinnaker              Active   10m
```

# OpenCloudCX Constituents and Credentials

To access the individual toolsets contained within the OpenCloudCX enclave, use the following URLs, with the appropriate DNS zone from above, paired with the credentials outlined. Each module used may have their own secrets and methods to retrieve in the module documentation

| Name       | Public URL<br />Internal URL ( [DNS SUFFIX] = `.svc.cluster.local` )                                   | Username | Password Location                                                |
| ---------- | ------------------------------------------------------------------------------------------------------ | -------- | ---------------------------------------------------------------- |
| Dashboard  | `https://dashboard.[DNS ZONE]`<br />`http://k8s-dashboard-kubernetes-dashboard.spinnaker.[DNS SUFFIX]` | None     | `connect.sh` token output                                        |
| Grafana    | `https://grafana.[DNS ZONE]` <br /> `http://grafana.opencloudcx.[DNS SUFFIX]`                          | admin    | AWS Secrets Manager [```grafana```] or `connect.sh` token output |
| Jenkins    | `https://jenkins.[DNS ZONE]` <br /> `http://jenkins.jenkins.[DNS SUFFIX]`                              | admin    | AWS Secrets Manager [```jenkins```] or `connect.sh` token output |
| Keycloak   | `https://keycloak.[DNS ZONE]` <br /> `http://keycloak.spinnaker.[DNS SUFFIX]`                          | user     | AWS Secrets Manager [```keycloak-admin```]                       |
| Prometheus | None <br /> `http://prometheus-server.opencloudcx.[DNS SUFFIX]`                                        | None     | N/A                                                              |
| Selenium   | `https://selenium.[DNS ZONE]` <br /> `http://selenium3-selenium-hub.jenkins.[DNS SUFFIX]`              | None     | None                                                             |
| Sonarqube  | `https://sonarqube.[DNS ZONE]` <br /> `http://sonarqube-sonarqube.jenkins.[DNS SUFFIX]`                | None     | AWS Secrets Manager [```sonarqube```]                            |
| Spinnaker  | `https://spinnaker.[DNS ZONE]` <br /> `http://spinnaker-deck.spinnaker.[DNS SUFFIX]`                   | None     | None                                                             |

# Environment Destruction

Select `Settings`, `Destruction and Deletion`, and `Queue Destroy Plan`.

If destruction terminates with an, re-execute the above instructions again. If the script times out again, delete the `spinnaker` namespace after connecting to the cluster using the instructions above.

```bash
$ kubectl delete namespace spinnaker

namespace "spinnaker" deleted
```

Once this command completes (it may take a while), re execute the `destroy` command again.

<div style="text-align: center; font-weight: bolder; color: red; font-size: 16pt;"><i>Developed by RIVA Solutions Inc 2022.  Authorized Use Only</i></div><br />
