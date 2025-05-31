#!/usr/bin/env python3

import torch
import time
import json
import sys
from datetime import datetime

def run_pytorch_benchmark():
    """Simple PyTorch matrix multiplication benchmark"""
    print("=== Mini-MLPerf PyTorch Benchmark ===")
    
    # Check GPU availability
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Using device: {device}")
    
    if torch.cuda.is_available():
        print(f"GPU: {torch.cuda.get_device_name(0)}")
        print(f"GPU Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.1f} GB")
    
    # Matrix multiplication benchmark
    size = 8192  # Large matrix for meaningful benchmark
    iterations = 100
    
    print(f"Matrix size: {size}x{size}")
    print(f"Iterations: {iterations}")
    
    # Create random matrices
    a = torch.randn(size, size, device=device, dtype=torch.float32)
    b = torch.randn(size, size, device=device, dtype=torch.float32)
    
    # Warmup
    for _ in range(10):
        torch.matmul(a, b)
    
    if torch.cuda.is_available():
        torch.cuda.synchronize()
    
    # Actual benchmark
    start_time = time.time()
    for _ in range(iterations):
        c = torch.matmul(a, b)
    
    if torch.cuda.is_available():
        torch.cuda.synchronize()
    
    end_time = time.time()
    
    total_time = end_time - start_time
    ops_per_second = iterations / total_time
    flops = 2 * size**3 * iterations  # Matrix multiplication FLOPs
    tflops = flops / total_time / 1e12
    
    return {
        "device": str(device),
        "matrix_size": size,
        "iterations": iterations,
        "total_time_seconds": total_time,
        "operations_per_second": ops_per_second,
        "tflops": tflops,
        "gpu_name": torch.cuda.get_device_name(0) if torch.cuda.is_available() else "N/A"
    }

def main():
    timestamp = datetime.utcnow().isoformat() + "Z"
    
    try:
        results = run_pytorch_benchmark()
        
        output = {
            "benchmark": "Mini-MLPerf",
            "version": "1.0",
            "framework": "PyTorch",
            "timestamp": timestamp,
            "results": results,
            "scu_metrics": {
                "ml_compute_score": results["tflops"]
            }
        }
        
        # Write results to file
        with open("/output/mlperf_results.json", "w") as f:
            json.dump(output, f, indent=2)
        
        print(f"\nBenchmark completed successfully!")
        print(f"Performance: {results['tflops']:.2f} TFLOPS")
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