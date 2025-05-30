#!/usr/bin/env bash
set -euo pipefail
out_dir="results"
mkdir -p "$out_dir"
ts=$(date +%Y%m%d)
mpirun -np 4 ./xhpcg | tee "$out_dir/hpcg_${ts}.log"
# Extract GFLOPS
gflops=$(grep -m1 "GFLOP/s" "$out_dir/hpcg_${ts}.log" | awk '{print $2}')
echo "date,gflops" > "$out_dir/hpcg_${ts}.csv"
echo "$ts,$gflops" >> "$out_dir/hpcg_${ts}.csv"
sha256sum "$out_dir/hpcg_${ts}.csv" > "$out_dir/hpcg_${ts}.csv.sha256"