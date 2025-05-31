#!/bin/bash

set -e

echo "=== STREAM Benchmark Starting ==="
echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "Hardware: $(nproc) CPU cores"

# Set number of threads based on available cores
export OMP_NUM_THREADS=${OMP_NUM_THREADS:-$(nproc)}
echo "OpenMP Threads: $OMP_NUM_THREADS"

# Run STREAM benchmark
echo "Running STREAM benchmark..."
./stream > /output/stream_$(date +%Y%m%d_%H%M%S).log 2>&1

# Extract results to JSON
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
cat > /output/stream_results.json << EOF
{
  "benchmark": "STREAM",
  "version": "5.10",
  "timestamp": "$TIMESTAMP",
  "hardware": {
    "cpu_cores": $(nproc),
    "threads": $OMP_NUM_THREADS
  },
  "results": {
    "copy_rate_mb_s": $(grep "Copy:" /output/stream_*.log | awk '{print $2}' || echo "0"),
    "scale_rate_mb_s": $(grep "Scale:" /output/stream_*.log | awk '{print $2}' || echo "0"),
    "add_rate_mb_s": $(grep "Add:" /output/stream_*.log | awk '{print $2}' || echo "0"),
    "triad_rate_mb_s": $(grep "Triad:" /output/stream_*.log | awk '{print $2}' || echo "0")
  },
  "scu_metrics": {
    "memory_bandwidth_score": $(grep "Triad:" /output/stream_*.log | awk '{print $2}' || echo "0")
  }
}
EOF

echo "STREAM benchmark completed successfully"
echo "Results written to /output/stream_results.json"