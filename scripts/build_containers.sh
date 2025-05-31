#!/bin/bash

set -e

echo "=== Building SCU Benchmark Containers ==="

# Change to benchmarks directory
cd "$(dirname "$0")/../benchmarks"

# Build each container
echo "Building STREAM container..."
docker build -t scu-stream:latest images/stream/

echo "Building HPCG container..."
docker build -t scu-hpcg:latest images/hpcg/

echo "Building Mini-MLPerf container..."
docker build -t scu-mini-mlperf:latest images/mini-mlperf/

echo "All containers built successfully!"
echo ""
echo "To tag and push to GHCR:"
echo "  docker tag scu-stream:latest ghcr.io/symmetricresearch/scu-stream:latest"
echo "  docker tag scu-hpcg:latest ghcr.io/symmetricresearch/scu-hpcg:latest"
echo "  docker tag scu-mini-mlperf:latest ghcr.io/symmetricresearch/scu-mini-mlperf:latest"
echo ""
echo "  docker push ghcr.io/symmetricresearch/scu-stream:latest"
echo "  docker push ghcr.io/symmetricresearch/scu-hpcg:latest"
echo "  docker push ghcr.io/symmetricresearch/scu-mini-mlperf:latest"