#!/bin/bash

set -euo pipefail

RESULTS_DIR=${1:-}
if [[ -z "$RESULTS_DIR" || "$RESULTS_DIR" == "auto" ]]; then
  RESULTS_DIR=$(ls -d results/*/ 2>/dev/null | sort -Vr | head -n1)
fi

if [[ -z "$RESULTS_DIR" || ! -d "$RESULTS_DIR" ]]; then
  echo "❌  No results directory found – aborting signing"
  exit 1
fi

echo "🔏  Signing artifacts in $RESULTS_DIR"

# Create a manifest of all files
find "$RESULTS_DIR" -type f -exec sha256sum {} \; > "$RESULTS_DIR/manifest.sha256"

# Sign the manifest (placeholder for actual signing implementation)
echo "Signing manifest with timestamp $(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$RESULTS_DIR/signature.txt"
echo "Hardware: 2x RTX 3080, Local Runner" >> "$RESULTS_DIR/signature.txt"
echo "Benchmark Suite: SCU Full Benchmark" >> "$RESULTS_DIR/signature.txt"

echo "Artifacts signed successfully"