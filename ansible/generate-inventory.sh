#!/usr/bin/env bash
set -euo pipefail

TERRAFORM_DIR="${1:-../terraform}"
SSH_KEY="${2:-~/.ssh/k8s-key.pem}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Reading Terraform outputs from: $TERRAFORM_DIR"
TF_OUTPUT=$(terraform -chdir="$TERRAFORM_DIR" output -json)

mapfile -t CP_IDS     < <(echo "$TF_OUTPUT" | jq -r '.control_plane_ids.value[]')
mapfile -t WORKER_IDS < <(echo "$TF_OUTPUT" | jq -r '.worker_ids.value[]')
ENDPOINT=$(echo "$TF_OUTPUT" | jq -r '.control_plane_endpoint.value // ""')

mkdir -p "$SCRIPT_DIR/inventory" "$SCRIPT_DIR/group_vars"

INVENTORY="$SCRIPT_DIR/inventory/hosts.ini"
{
  echo "[control_plane]"
  for i in "${!CP_IDS[@]}"; do
    echo "control-plane-$((i+1)) ansible_host=${CP_IDS[$i]} ansible_user=ubuntu ansible_ssh_private_key_file=$SSH_KEY"
  done

  echo ""
  echo "[workers]"
  for i in "${!WORKER_IDS[@]}"; do
    echo "worker-$((i+1)) ansible_host=${WORKER_IDS[$i]} ansible_user=ubuntu ansible_ssh_private_key_file=$SSH_KEY"
  done

  echo ""
  echo "[k8s:children]"
  echo "control_plane"
  echo "workers"
} > "$INVENTORY"

echo "Inventory written to $INVENTORY"

GROUP_VARS="$SCRIPT_DIR/group_vars/all.yaml"
{
  if [ -n "$ENDPOINT" ]; then
    echo "control_plane_endpoint: \"$ENDPOINT\""
  else
    echo "# control_plane_endpoint will be populated after the NLB module is added to Terraform"
    echo "# control_plane_endpoint: \"\""
  fi
} > "$GROUP_VARS"

echo "group_vars/all.yaml written to $GROUP_VARS"
