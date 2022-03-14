<div style="text-align: center; font-weight: bolder; color: red; font-size: 16pt;"><i>Developed by RIVA Solutions Inc 2022.  Authorized Use Only</i></div><br />

# OpenCloudCX setup in AWS

This repository contains a framework to use for creation of an OpenCloudCX cluster. After cloning this repository, refer to the below sections for configuration. These instructions are intended to be executed after a project has been created per configuration instructions.

# Toolsets

## Terraform

The entire infrastructure is installed and managed using [Hashicorp Terraform](https://www.terraform.io/).

## Required

| Toolset                                                         | Links                                                                                                                                                                                               | Notes                                                                                                                                                                                                                                                                                                                                                                          |
| --------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Terraform&nbsp;(at least version&nbsp;1.0.8) or Terraform Cloud | [Download](https://releases.hashicorp.com/terraform/1.0.8/) \|\| [Terraform Cloud](https://www.terraform.io/cloud?utm_source=hashicorp_com&utm_content=pricing_tfc)                                 | Terraform is distributed as a single binary. Install Terraform by unzipping it and moving it to a directory included in your system's [PATH](https://superuser.com/questions/284342/what-are-path-and-other-environment-variables-and-how-can-i-set-or-use-them). <br />**This project has been tested with Terraform 1.0.8 -- Will be updated as newer versions are tested.** |
| AWS&nbsp;CLI                                                    | [Instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) \|\| [Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) | This link provides information for getting started with version 2 of the AWS Command Line Interface (AWS CLI)                                                                                                                                                                                                                                                                  |
| kubectl                                                         | [Instructions](https://kubernetes.io/docs/tasks/tools/#kubectl)                                                                                                                                     | Allows commands to be executed against Kubernetes clusters                                                                                                                                                                                                                                                                                                                     |
| Git                                                             | [Instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)                                                                                                                       | Need to run this command to avoid a CRLF issues: git config --global core.autocrlf input                                                                                                                                                                                                                                                                                       |

## Optional

| Toolset                           | Links                                                                      | Notes                                                                                                                |
| --------------------------------- | -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Windows Subsystem for Linux (WSL) | [Instructions](https://docs.microsoft.com/en-us/windows/wsl/install-win10) | This is a robust linux capability for Windows 10 and Windows 11. Linux instructions are written for Ubuntu 20.04 LTS |

## Mac OSX Required

| Toolset                     | Links                                | Notes                                                                                       |
| --------------------------- | ------------------------------------ | ------------------------------------------------------------------------------------------- |
| Brew Package Manager        | [Install Homebrew](https://brew.sh/) | MacOSX Package Manager                                                                      |
| tfenv                       | `brew install tfenv`                 | Terraform version manager `tfenv list-remote` -> `tfenv install 1.0.8` -> `tfenv use 1.0.8` |
| Command-line JSON Processor | `brew install jq`                    | Lightweight and flexible command-line JSON processor                                        |

# Environment creation

## Initialize Terraform and Execute

### `terraform init`

The `init` command tells Terraform to initialize the project from the current working directory of terraform configurations. If commands relying on initialization are executed before this step, the command will fail with an error.

From [terraform.io](https://www.terraform.io/docs/cli/init/index.html)

> Initialization performs several tasks to prepare a directory, including accessing state in the configured backend, downloading and installing provider plugins, and downloading modules. Under some conditions (usually when changing from one backend to another), it might ask the user for guidance or confirmation.

### `terraform apply`

From [terraform.io](https://www.terraform.io/docs/cli/commands/apply.html)

> The terraform apply command performs a plan just like terraform plan does, but then actually carries out the planned changes to each resource using the relevant infrastructure provider's API. It asks for confirmation from the user before making any changes, unless it was explicitly told to skip approval.

### Command Execution

Execute these two commands in succession.

```
$ terraform init
$ terraform apply --auto-approve
```

If you receive the following error, confirm the s3 state bucket referenced above is correct

```bash
Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Error refreshing state: AccessDenied: Access Denied
        status code: 403, request id: <string> host id: <string>
```

---

<!-- _NOTE: Terraform assumes the current `[default]` profile contains the appropriate credentials for environment initialization. If this is not correct, each Terraform command needs to be prefixed with `AWS_PROFILE=` and the desired AWS profile to use._
On Linux this can be found in your home directory .aws update both credentials and config file
On Windows C:\Users\[username]\.aws update both credentials and config file

```
$ AWS_PROFILE=<profile name> terraform init
$ AWS_PROFILE=<profile name> terraform apply --auto-approve
```

--- -->

Once Terraform instructions have been applied, the following message will be displayed

<span style='font-size: 13pt; color: green'>Apply complete! Resources: ### added, 0 changed, 0 destroyed.</span>

# Environment Validation

Once a successful message of completion has been displayed, run the apprioriate script to connect.

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

### `terraform destroy`

From [terraform.io](https://www.terraform.io/docs/cli/commands/destroy.html)

> The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.

Execute the command.

```
$ terraform destroy --auto-approve
```

If the script terminates with a timout error, re-execute the `destroy` command again. If the script times out again, delete the `spinnaker` namespace

```bash
$ kubectl delete namespace spinnaker

namespace "spinnaker" deleted
```

Once this command completes (it may take a while), re execute the `destroy` command again.

<div style="text-align: center; font-weight: bolder; color: red; font-size: 16pt;"><i>Developed by RIVA Solutions Inc 2022.  Authorized Use Only</i></div><br />
