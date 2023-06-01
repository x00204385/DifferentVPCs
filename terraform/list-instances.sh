#!/bin/bash
aws ec2 describe-instances --filters "Name=tag-value,Values=wordpress-asg-instance" --query 'Reservations[].Instances[].[InstanceId,Placement.AvailabilityZone,PublicIpAddress,PrivateIpAddress]' --output table
