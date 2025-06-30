#!/bin/bash

set -e

echo "=== Starting Infrastructure Deployment ==="

# Navigate to terraform directory
cd terraform

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Plan deployment
echo "Planning infrastructure..."
terraform plan

# Apply configuration
echo "Creating infrastructure..."
terraform apply -auto-approve

# Wait for instances to be ready
echo "Waiting for instances to be ready..."
sleep 30

# Navigate to ansible directory
cd ../ansible

# Test connectivity
echo "Testing connectivity..."
ansible all -m ping

# Deploy web application
echo "Deploying web application..."
ansible-playbook playbooks/deploy_webapp.yml

# Setup monitoring
echo "Setting up monitoring..."
WEBAPP_IP=$(cd ../terraform && terraform output -raw webapp_public_ip)
ansible-playbook playbooks/setup_monitoring.yml -e "WEBAPP_IP=$WEBAPP_IP"

# Display access information
echo "=== Deployment Complete ==="
cd ../terraform
echo "Web Application: $(terraform output webapp_url)"
echo "Grafana Dashboard: $(terraform output grafana_url)"
echo "Prometheus: http://$(terraform output monitoring_public_ip):9090"
