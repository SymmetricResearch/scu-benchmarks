#!/usr/bin/env python3

import numpy as np
import time
import json
import sys
import os
from datetime import datetime

def run_numpy_benchmark():
    """Simple NumPy matrix multiplication benchmark"""
    print("=== Mini-MLPerf NumPy Benchmark (Stub) ===")
    
    # Check for GPU via nvidia-smi
    gpu_available = os.system("nvidia-smi > /dev/null 2>&1") == 0
    device = "gpu" if gpu_available else "cpu"
    print(f"Using device: {device}")
    
    # Matrix multiplication benchmark
    size = 2048  # Smaller matrix for CPU-only benchmark
    iterations = 10
    
    print(f"Matrix size: {size}x{size}")
    print(f"Iterations: {iterations}")
    
    # Create random matrices
    a = np.random.randn(size, size).astype(np.float32)
    b = np.random.randn(size, size).astype(np.float32)
    
    # Warmup
    for _ in range(3):
        np.dot(a, b)
    
    # Actual benchmark
    start_time = time.time()
    for _ in range(iterations):
        c = np.dot(a, b)
    
    end_time = time.time()
    
    total_time = end_time - start_time
    ops_per_second = iterations / total_time
    flops = 2 * size**3 * iterations  # Matrix multiplication FLOPs
    gflops = flops / total_time / 1e9
    
    return {
        "device": device,
        "matrix_size": size,
        "iterations": iterations,
        "total_time_seconds": total_time,
        "operations_per_second": ops_per_second,
        "gflops": gflops,
        "framework": "NumPy"
    }

def main():
    timestamp = datetime.utcnow().isoformat() + "Z"
    
    try:
        results = run_numpy_benchmark()
        
        output = {
            "benchmark": "Mini-MLPerf",
            "version": "1.0-stub",
            "framework": "NumPy",
            "timestamp": timestamp,
            "results": results,
            "scu_metrics": {
                "ml_compute_score": results["gflops"]
            }
        }
        
        # Write results to file
        with open("/output/mlperf_results.json", "w") as f:
            json.dump(output, f, indent=2)
        
        print(f"\nBenchmark completed successfully!")
        print(f"Performance: {results['gflops']:.2f} GFLOPS")
        print("Results written to /output/mlperf_results.json")
        
    except Exception as e:
        error_output = {
            "benchmark": "Mini-MLPerf",
            "timestamp": timestamp,
            "error": str(e),
            "status": "failed"
        }
        
        with open("/output/mlperf_results.json", "w") as f:
            json.dump(error_output, f, indent=2)
        
        print(f"Benchmark failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()