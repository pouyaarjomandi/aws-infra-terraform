#!/bin/bash
set -euo pipefail

ALB_SG="$(terraform output -raw alb_security_group_id)"

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
sed "s|<ALB_SG_ID>|$ALB_SG|g" k8s/ingress.yaml | kubectl apply -f -
