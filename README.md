# Full example of OpenCloudCX setup in AWS

This repository contains a framework to use for creation of an OpenCloudCX cluster. After cloning this repository, refer to the below sections for configuration.

# Toolsets

|Toolset|Links|Notes|
|---|---|---|
|Terraform&nbsp;(at least version&nbsp;1.0.8)|[Download](https://releases.hashicorp.com/terraform/1.0.8/) | Terraform is distributed as a single binary. Install Terraform by unzipping it and moving it to a directory included in your system's [PATH](https://superuser.com/questions/284342/what-are-path-and-other-environment-variables-and-how-can-i-set-or-use-them). <br />**This project has been tested with Terraform 1.0.8 -- Will be updated as newer versions are tested.**|
|AWS&nbsp;CLI|[Instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) \|\| [Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)|This link provides information for getting started with version 2 of the AWS Command Line Interface (AWS CLI)|
|kubectl|[Instructions](https://kubernetes.io/docs/tasks/tools/#kubectl)|Allows commands to be executed against Kubernetes clusters|
| Git |[Instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)| Need to run this command to avoid a CRLF issues: git config --global core.autocrlf input|

# Setup

Once all toolsets are installed and verified to be operational, configure the cloned bootstrap project.

## AWS S3 State Bucket
If remote state storge is desired, follow the instructions in this section. If not, skip to *Project Variables*. This file is not required for successful environment generation.

OpenCloudCX can use Terraform state buckets to store all infrastructure snapshot information (e.g., S3 buckets, VPC, EC2, EKS). State buckets allow for teams to have a centralized souce of truth for the infrastructure. Per AWS S3 requirements, this bucket name needs to be globally unique. This bucket is not created automatically and needs to be in place before the terraform project is initialized. 

Follows [these]() instructions to create a unique bucket in the account where OpenCloudCX is going to be installed. A good convention for this project is to create and use ```opencloucx-state-bucket-####``` and replace ```####``` with the last 4 digits of the AWS account number. 

Once the bucket has been created, copy ```state.tf.example``` and rename the copy (not the original) to ```state.tf```. Update the requested and save. 

```bash
  backend "s3" {
    key    = "[terraform-state-filename]"
    bucket = "[bucket name]"
    region = "[region]"
  }
```

## Variables

Create a copy of the ```variables.example.tfvars``` file and name it ```variables.auto.tfvars```. If another filename needs to be used, Terraform automatically loads a number of variable definitions files if named the following way:
* Files named exactly ```terraform.tfvars``` or ```terraform.tfvars.json```
* Any files with names ending in ```.auto.tfvars``` or ```.auto.tfvars.json```

Update the variables within the file for any desired configuration changes

<table width=100%>
<tr>
  <th width="15%" style="font-weight:bolder;">Variable</th>
  <th width="35%" style="font-weight:bolder;">Explanation</th>
  <th width="50%" style="font-weight:bolder;">Example</th>
</tr>
<tr>
  <td>eks_map_roles</td>
  <td>Additional IAM roles to add to the aws-auth configmap. 
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
  <td>eks_map_users</td>
  <td>Additional IAM users to add to the aws-auth configmap</td>
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
  <td>dns_zone</td>
  <td>To experience the full impact of an OpenCloudCX installation, a valid, publicly accessible DNS zone needs to be supplied within the configuration. The default DNS Zone of ```spinnaker.internal``` can be used for initial prototyping with appropriate local hosts file manipulation.</td>
  <td>

  ```bash
  dns_zone           = "spinnaker.internal"
  ```
</td>
</tr>

</table>

# Modules

TODO: Talk about modules with link to PLUGINS.md