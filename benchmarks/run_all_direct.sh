#!/bin/bash

set -e

FULL_MODE=false
QUICK_TEST=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --full)
      FULL_MODE=true
      shift
      ;;
    --quick_test)
      QUICK_TEST=true
      FULL_MODE=true  # Enable MLPerf but in quick mode
      shift
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

if [ "$QUICK_TEST" = true ]; then
  echo "Running SCU Benchmarks (Quick Test Mode: baseline models only) - Direct Docker"
elif [ "$FULL_MODE" = true ]; then
  echo "Running SCU Benchmarks (Full Mode: all models including ResNet-50 + BERT tiny) - Direct Docker"
else
  echo "Running SCU Benchmarks (Standard Mode: STREAM + HPCG only) - Direct Docker"
fi

mkdir -p ../results/latest

echo "Starting STREAM benchmark..."
docker run --rm \
  -v "$(pwd)/../results:/output" \
  scu-stream:latest || \
  echo "⚠️ STREAM benchmark failed or container not available"

echo "Starting HPCG benchmark..."
docker run --rm \
  --gpus all \
  -v "$(pwd)/../results:/output" \
  scu-hpcg:latest || \
  echo "⚠️ HPCG benchmark failed or container not available"

if [ "$FULL_MODE" = true ]; then
  MLPERF_ARGS=""
  if [ "$QUICK_TEST" = true ]; then
    MLPERF_ARGS="--quick_test"
    echo "Starting Mini-MLPerf benchmark (quick test mode)..."
  else
    echo "Starting Mini-MLPerf benchmark (full suite: ResNet-50 + BERT tiny)..."
  fi
  
  docker run --rm \
    --gpus all \
    -v "$(pwd)/../results:/output" \
    scu-mini-mlperf:latest $MLPERF_ARGS || \
    echo "⚠️ Mini-MLPerf benchmark failed or container not available"
fi

echo "All benchmarks completed!"
echo "Results stored in ../results/latest/"