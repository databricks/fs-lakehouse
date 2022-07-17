---
page_title: "Provisioning Secure Databricks Workspaces on AWS with Terraform"
---

# Module to Deploy a Lakehouse Blueprint using Best Practices and Industry Helper Libraries

<<<<<<< HEAD
This module uses the following input variables. Please all variables here in a terraform.tfvars file (outside the github project) and reference it using `terraform apply -var-file="<location for tfvars file>/terraform.tfvars"`.

## Input Variables

- `databricks_account_id`: The ID per Databricks AWS account used for accessing account management APIs. After the AWS E2 account is created, this is available after logging into [https://accounts.cloud.databricks.com](https://accounts.cloud.databricks.com).
- `databricks_account_username`: E2 user account email address
- `databricks_account_password` - E2 account password
- `region` - region in which all AWS resources are deployed
- `relay_vpce_service` - VPC endpoint service for backend relays. This is region-dependent; for example, for us-east-1 the service is available on the Databricks Private Link [documentation](https://docs.databricks.com/administration-guide/cloud-configurations/aws/privatelink.html#create-the-aws-vpc-endpoints-for-your-aws-region) - `com.amazonaws.vpce.us-east-1.vpce-svc-00018a8c3ff62ffdf`
- `workspace_vpce_service` - VPC endpoint service for workspace communication. This is region-dependent; for example, for us-east-1 the service is available on the Databricks Private Link [documentation](https://docs.databricks.com/administration-guide/cloud-configurations/aws/privatelink.html#create-the-aws-vpc-endpoints-for-your-aws-region) - `com.amazonaws.vpce.us-east-1.vpce-svc-09143d1e626de2f04`
- `vpce_subnet_cidr` - CIDR for deployment of the VPC endpoint subnets
- `vpc_id` - VPC identifier for existing customer managed VPC
- `subnet_ids` - private subnets associated with the Databricks-compliant VPC. This should be a list of strings specified by type(string)
- `security_group_id` - security group ID used for VPC subnets
- `cross_account_arn` - existing cross-account role arn

## Output Variables

- `workspace_url` - URL which allows users to log into the created regulated workspace
- `workspace_id` - Numeric ID mapping to the newly created regulated workspace

## Usage
=======
This modules uses the following input variables. Please all variables here in a terraform.tfvars file (outside the github project) and reference it using `terraform apply -var-file="<location for tfvars file>/terraform.tfvars"`.

### Input Variables 
- `databricks_account_id`: The ID per Databricks AWS account used for accessing account management APIs. After the AWS E2 account is created, this is available after logging into [https://accounts.cloud.databricks.com](https://accounts.cloud.databricks.com).
- `databricks_account_username`: E2 user account email address
- `databricks_account_password` - E2 account password
- `AWS_PROFILE` - AWS profile used for the AWS CLI and authentication for terraform to AWS APIs
- `AWS_PROFILE` - region in which all AWS resources are deployed
- `relay_vpce_service` - VPC endpoint service for backend relays. This is region-dependent; for example, for us-east-1 the service is available on the Databricks Private Link documentation - `com.amazonaws.vpce.us-east-1.vpce-svc-00018a8c3ff62ffdf`
- `workspace_vpce_service` - VPC endpoint service for workspace communication. This is region-dependent; for example, for us-east-1 the service is available on the Databricks Private Link documentation - `com.amazonaws.vpce.us-east-1.vpce-svc-09143d1e626de2f04`
- `vpce_subnet_cidr` - CIDR for deployment of the VPC endpoint subnets
-  `vpc_id` - VPC identifier for existing customer managed VPC
-  `subnet_ids` - private subnets associated with the Databricks-compliant VPC. This should be a list of strings specified by type(string)
-  `security_group_id` - security group ID used for VPC subnets
-  `cross_account_arn` - existing cross-account role arn

### Output Variables 

-  `workspace_url` - URL which allows users to log into the created regulated workspace
-  `workspace_id` - Numeric ID mapping to the newly created regulated workspace


### Usage
>>>>>>> d7d0625 (add new files for module)

```hcl
module "aws_customer_managed_vpc" {
  source = "databricks/aws_customer_managed_vpc/"
  
  databricks_account_id = # see description above
  databricks_account_username = # see description above
  databricks_account_password = # see description above
  region = # see description above
  relay_vpce_service = # see description above
  workspace_vpce_service = # see description above
  vpce_subnet_cidr = # see description above
  vpc_id = # see description above
  subnet_ids = # see description above
  security_group_id = # see description above
  cross_account_arn = # see description above
  
}
```

## Provider initialization

Initialize [provider with `mws` alias](https://www.terraform.io/language/providers/configuration#alias-multiple-provider-configurations) to set up account-level resources.

```hcl
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
<<<<<<< HEAD
      version = "1.0.0"
=======
      version = "0.5.0"
>>>>>>> d7d0625 (add new files for module)
    }
    aws = {
      source = "hashicorp/aws"
      version = "3.49.0"
    }
  }
}

provider "aws" {
  region = var.region
}

// initialize provider in "MWS" mode for provisioning workspace with AWS PrivateLink
provider "databricks" {
  alias    = "mws"
  host     = "https://accounts.cloud.databricks.com"
  username = var.databricks_account_username
  password = var.databricks_account_password
}


```