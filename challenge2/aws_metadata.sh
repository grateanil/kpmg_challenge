#!/bin/bash

# Query AWS EC2 instance metadata
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
instance_type=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
availability_zone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Create JSON output
json_output=$(jq -n --arg instance_id "$instance_id" --arg instance_type "$instance_type" --arg availability_zone "$availability_zone" '{instance_id: $instance_id, instance_type: $instance_type, availability_zone: $availability_zone}')

echo $json_output

