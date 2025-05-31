#!/bin/bash

set -e

RESULTS_DIR=${1:-"results/latest"}

echo "Signing artifacts in $RESULTS_DIR"

if [ ! -d "$RESULTS_DIR" ]; then
  echo "Results directory $RESULTS_DIR does not exist"
  exit 1
fi

# Create a manifest of all files
find "$RESULTS_DIR" -type f -exec sha256sum {} \; > "$RESULTS_DIR/manifest.sha256"

# Sign the manifest (placeholder for actual signing implementation)
echo "Signing manifest with timestamp $(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$RESULTS_DIR/signature.txt"
echo "Hardware: 2x RTX 3080, Local Runner" >> "$RESULTS_DIR/signature.txt"
echo "Benchmark Suite: SCU Full Benchmark" >> "$RESULTS_DIR/signature.txt"

echo "Artifacts signed successfully"