#!/usr/bin/env bash
set -euo pipefail
REGION="${1:-ap-northeast-2}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="$(terraform -chdir="$ROOT/infra" output -raw flink_application_name)"

if [ -z "$APP_NAME" ]; then
  echo "[ERROR] Failed to get flink_application_name from terraform output." >&2
  exit 1
fi

echo "Starting Flink application: $APP_NAME ($REGION)..."
aws kinesisanalyticsv2 start-application --region "$REGION" --application-name "$APP_NAME"

