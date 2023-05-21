#/bin/bash
set +x
aws ec2 delete-network-acl-entry --network-acl-id $(terraform output -raw primary_nacl) --rule-number 50 --ingress 
