#!/bin/bash

set -e

echo "=== Mini-MLPerf Benchmark Starting ==="
echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Check GPU availability
nvidia-smi || echo "Warning: nvidia-smi not available"

# Run the Python benchmark
cd /app
python3 mini_mlperf.py

echo "Mini-MLPerf benchmark completed"