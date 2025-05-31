#!/bin/bash

set -e

FULL_MODE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --full)
      FULL_MODE=true
      shift
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

echo "Running SCU Benchmarks (Full Mode: $FULL_MODE) - Direct Docker"
mkdir -p ../results/latest

echo "Starting STREAM benchmark..."
docker run --rm \
  -v "$(pwd)/../results:/results" \
  ghcr.io/symmetricresearch/scu-stream:latest || \
  echo "⚠️ STREAM benchmark failed or container not available"

echo "Starting HPCG benchmark..."
docker run --rm \
  --runtime=nvidia \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -v "$(pwd)/../results:/results" \
  ghcr.io/symmetricresearch/scu-hpcg:latest || \
  echo "⚠️ HPCG benchmark failed or container not available"

if [ "$FULL_MODE" = true ]; then
  echo "Starting Mini-MLPerf benchmark..."
  docker run --rm \
    --runtime=nvidia \
    -e NVIDIA_VISIBLE_DEVICES=all \
    -v "$(pwd)/../results:/results" \
    ghcr.io/symmetricresearch/scu-mini-mlperf:latest || \
    echo "⚠️ Mini-MLPerf benchmark failed or container not available"
fi

echo "All benchmarks completed!"
echo "Results stored in ../results/latest/"