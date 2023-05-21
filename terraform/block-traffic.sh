#/bin/bash
set +x
aws ec2 create-network-acl-entry --network-acl-id $(terraform output -raw primary_nacl) --rule-number 50 --protocol tcp --rule-action deny --ingress --port-range From=80,To=80 --cidr-block 0.0.0.0/0
