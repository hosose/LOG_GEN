#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGION="${1:-ap-northeast-2}"
APP_NAME="$(terraform -chdir="$ROOT/infra" output -raw flink_application_name 2>/dev/null || true)"

if [ -z "$APP_NAME" ]; then
  echo "[INFO] Flink application is not deployed or infrastructure has been destroyed."
  exit 0
fi

aws kinesisanalyticsv2 describe-application \
  --region "$REGION" \
  --application-name "$APP_NAME" \
  --query 'ApplicationDetail.{Name:ApplicationName,Status:ApplicationStatus,Runtime:RuntimeEnvironment}' \
  --output table

