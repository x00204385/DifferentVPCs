# DifferentVPCs
Experiment to deploy infrastructure in different VPCs.
#
#
Experiment to use terraform workspaces to create infrastructure in us-east-1 and eu-west-1. Workspaces created for each region and also created eu-west-1.tfvars and us-east-1.tfvars.
```
terraform workspace new us-east-1
terraform workspace new eu-west-1
``
Then create resources based on .tfvars files:
```
terraform workspace select us-east-1
terraform apply -var-file us-east-1.tfvars
terraform workspace select eu-west-1
terraform apply -var-file eu-west-1.tfvars
```
Noted that if the region is not set or is set incorrectly then this doesn’t work. Having the region set in an AWS profile can confuse things if the var file is not specified. 
