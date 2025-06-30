#!/bin/bash

set -e

echo "=== Starting Infrastructure Cleanup ==="

# Navigate to ansible directory
cd ansible

# Run cleanup playbook
echo "Cleaning up Docker resources..."
ansible-playbook playbooks/cleanup.yml || true

# Navigate to terraform directory
cd ../terraform

# Destroy infrastructure
echo "Destroying infrastructure..."
terraform destroy -auto-approve

echo "=== Cleanup Complete ==="
