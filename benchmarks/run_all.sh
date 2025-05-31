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

echo "Running SCU Benchmarks (Full Mode: $FULL_MODE)"
mkdir -p ../results/latest

echo "Starting STREAM benchmark..."
docker compose run --rm stream

echo "Starting HPCG benchmark..."
docker compose run --rm hpcg

if [ "$FULL_MODE" = true ]; then
  echo "Starting Mini-MLPerf benchmark..."
  docker compose run --rm mini-mlperf
fi

echo "All benchmarks completed!"
echo "Results stored in ../results/latest/"