# VPC Module

This module provisions an AWS VPC network that can be used to run EKS clusters.
So in here we will be
- creating VPC
- creating public/private subnet
- creating routtables for the respected subnets and vpc
- creating internet gateway (igw) so that the public subnet will be accessible to internet
- creating a NAT gatweay so that resource in private subnet can talk with internet and not vice-versa

## Usage

```hcl
provider "aws" {
  region  = "us-east-1"
}

module "vpc" {
  source  = "./modules/vpc"

  name               = "us-east-1"
  cidr_block         = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
```

This configuration will cause 6 subnets to be launched in the 3 chosen
availability zones.

3 smaller "public" subnets, that can be used for external ingress etc. And
3 larger subnets that will be used for the Pod network, internal ingress and
worker nodes.

In this example the following subnets would be created:

| zone         | public        | private        |
|--------------|---------------|----------------|
| `us-east-1a` | `10.0.0.0/22` | `10.0.32.0/19` |
| `us-east-1b` | `10.0.4.0/22` | `10.0.64.0/19` |
| `us-east-1b` | `10.0.8.0/22` | `10.0.96.0/19` |

This module outputs a [config object](./outputs.tf) that may be used to configure
the cluster module's `vpc_config` variable.

e.g:
```hcl
module "network" {
  source  = "./modules/vpc"

  name               = "us-east-1"
  cidr_block         = "10.5.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-2c"]
}


## Features

As well as configuring the subnets and route table of the provisioned VPC, this
module also provisions internet and NAT gateways, to provide internet access to
nodes running in all subnets.

## Restrictions

In order to run an EKS cluster you must create subnets in at least 3 availability
zones.

Because of the way this module subdivides `cidr_block` it can only accommodate
up to 7 subnet pairs.

The size of each subnet is relative to the CIDR block chosen for the VPC.


