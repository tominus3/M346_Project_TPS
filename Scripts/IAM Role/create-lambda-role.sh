#!/bin/bash
set -e

ROLE_NAME="FaceRecognitionLambdaRole"
POLICY_NAME="FaceRecognitionLambdaPolicy"

echo "=== IAM-Rolle erstellen ==="
aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document file://trust-policy.json >/dev/null || echo "Rolle existiert bereits"

aws iam create-policy \
  --policy-name "$POLICY_NAME" \
  --policy-document file://permissions-policy.json >/dev/null || echo "Policy existiert bereits"

POLICY_ARN=$(aws iam list-policies --scope Local --query "Policies[?PolicyName=='$POLICY_NAME'].Arn" --output text)
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$POLICY_ARN" || echo "Policy bereits angehängt"

ROLE_ARN=$(aws iam get-role --role-name "$ROLE_NAME" --query 'Role.Arn' --output text)
echo "Rolle ARN: $ROLE_ARN"
