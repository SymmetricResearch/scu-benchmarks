#!/bin/bash

set -e

echo "=== Enhanced Mini-MLPerf Benchmark Starting ==="
echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Check GPU availability
nvidia-smi || echo "Warning: nvidia-smi not available"

# Parse command line arguments
QUICK_TEST=""
if [[ "$1" == "--quick_test" ]]; then
    QUICK_TEST="--quick_test"
    echo "Mode: Quick test (baseline model only)"
else
    echo "Mode: Full suite (baseline + ResNet-50 + BERT tiny)"
fi

# Run the enhanced Python benchmark
cd /app
python3 enhanced_mlperf.py $QUICK_TEST --output /output

echo "Enhanced Mini-MLPerf benchmark completed"