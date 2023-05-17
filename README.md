# DifferentVPCs
Experiment to deploy infrastructure in different VPCs. Use terraform to build repeatable environments in different regions and eventually different cloud service providers. 
#
#
Experiment to use terraform workspaces to create infrastructure in us-east-1 and eu-west-1. Workspaces created for each region and also created eu-west-1.tfvars and us-east-1.tfvars.
```
terraform workspace new us-east-1
terraform workspace new eu-west-1
```
Then create resources based on .tfvars files:
```
terraform workspace select us-east-1
terraform apply -var-file us-east-1.tfvars
terraform workspace select eu-west-1
terraform apply -var-file eu-west-1.tfvars
```
Noted that if the region is not set or is set incorrectly then this doesn’t work. Having the region set in an AWS profile can confuse things if the var file is not specified. 

Sample contents of *.tfvars file

```
region = "us-east-1"
vpc_cidr_block = "10.2.0.0/16"
public_subnet_cidr_blocks = ["10.2.1.0/24", "10.2.3.0/24"]
private_subnet_cidr_blocks = ["10.2.2.0/24", "10.2.4.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]
instance-ami = "ami-007855ac798b5175e"
key-pair = "******"
```
