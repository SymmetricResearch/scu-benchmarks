#!/bin/bash

set -e

echo "=== HPCG Benchmark Starting ==="
echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Check GPU availability
nvidia-smi || echo "Warning: nvidia-smi not available"

# Run HPCG benchmark
cd /app/hpcg-3.1/build
echo "Running HPCG benchmark..."

# Set problem size based on available GPU memory (default: small test)
PROBLEM_SIZE=${HPCG_PROBLEM_SIZE:-"104 104 104"}
RUNTIME=${HPCG_RUNTIME:-60}

echo "Problem size: $PROBLEM_SIZE"
echo "Runtime: ${RUNTIME}s"

# Create HPCG configuration
cat > hpcg.dat << EOF
HPCG benchmark input file
Sandia National Laboratories; University of Tennessee, Knoxville
$PROBLEM_SIZE
$RUNTIME
EOF

# Run the benchmark
./xhpcg > /output/hpcg_$(date +%Y%m%d_%H%M%S).log 2>&1

# Extract results to JSON
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
GFLOPS=$(grep "GFLOP/s rating" /output/hpcg_*.log | tail -1 | awk '{print $NF}' || echo "0")

cat > /output/hpcg_results.json << EOF
{
  "benchmark": "HPCG",
  "version": "3.1",
  "timestamp": "$TIMESTAMP",
  "configuration": {
    "problem_size": "$PROBLEM_SIZE",
    "runtime_seconds": $RUNTIME
  },
  "hardware": {
    "gpu_count": $(nvidia-smi -L | wc -l || echo "0")
  },
  "results": {
    "gflops": $GFLOPS,
    "valid": $(grep -q "PASSED" /output/hpcg_*.log && echo "true" || echo "false")
  },
  "scu_metrics": {
    "compute_score": $GFLOPS
  }
}
EOF

echo "HPCG benchmark completed successfully"
echo "Results written to /output/hpcg_results.json"
echo "GFLOP/s rating: $GFLOPS"