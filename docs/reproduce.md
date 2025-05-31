# Reproducible SCU Benchmark Guide

This guide enables external auditors to reproduce SCU benchmark results with cryptographic verification.

## Quick Start (5 minutes)

```bash
# 1. Clone repository
git clone https://github.com/SymmetricResearch/scu-benchmarks.git
cd scu-benchmarks

# 2. Run benchmarks (requires Docker + GPU)
bash benchmarks/run_all_direct.sh --quick_test

# 3. Verify results with Ed25519 signatures
./scripts/ed25519_verify.sh auto
```

## Prerequisites

- **Docker**: Container runtime for isolated benchmark execution
- **NVIDIA GPU**: RTX 3060+ recommended (CUDA 11.0+)
- **Docker GPU support**: `nvidia-docker2` or `nvidia-container-toolkit`
- **Disk space**: 10GB for images + results
- **Time**: 5-8 minutes per full run

## Benchmark Modes

| Mode | Command | Coverage | Runtime | Use Case |
|------|---------|----------|---------|----------|
| **Quick** | `--quick_test` | STREAM + HPCG + MLPerf baseline | ~5.5 min | CI validation |
| **Standard** | (default) | STREAM + HPCG | ~5 min | Basic benchmarking |
| **Full** | `--full` | + ResNet-50 + BERT tiny | ~8 min | Complete validation |

## Step-by-Step Reproduction

### 1. Environment Setup

```bash
# Verify GPU access
nvidia-smi

# Verify Docker GPU support
docker run --rm --gpus all nvidia/cuda:11.0-base-ubuntu20.04 nvidia-smi
```

### 2. Benchmark Execution

```bash
# Build containers locally (recommended for reproducibility)
cd benchmarks/images/stream && docker build -t scu-stream:latest .
cd ../hpcg && docker build -t scu-hpcg:latest .
cd ../mini-mlperf && docker build -t scu-mini-mlperf:latest .

# Return to repo root
cd ../../..

# Run full benchmark suite
bash benchmarks/run_all_direct.sh --full
```

### 3. Result Structure

After completion, results are saved in `results/YYYYMMDD_HHMMSS/`:

```
results/20250131_143022/
├── stream_results.json       # STREAM bandwidth measurements
├── hpcg_results.json         # HPCG GFLOPS performance
├── mlperf_results.json       # Mini-MLPerf model timings
├── manifest.sha256           # File integrity checksums
├── manifest.sig              # Ed25519 digital signature
├── gpu_stats_pre.csv         # Pre-benchmark GPU telemetry
├── gpu_stats_post.csv        # Post-benchmark GPU telemetry
└── cost_report.txt           # Estimated compute cost
```

### 4. Cryptographic Verification

#### SHA256 Integrity Check
```bash
# Verify file checksums
cd results/YYYYMMDD_HHMMSS/
sha256sum -c manifest.sha256
```

#### Ed25519 Signature Verification
```bash
# Auto-verify latest results
./scripts/ed25519_verify.sh auto

# Verify specific results with custom public key
./scripts/ed25519_verify.sh results/20250131_143022/ custom_public.pub
```

The verification script will output:
- ✅ `Signature verification: PASSED` - Results are authentic
- ❌ `Signature verification: FAILED` - Results may be tampered

## Expected Results (Reference Values)

### STREAM (Memory Bandwidth)
- **Copy**: 800-900 GB/s (RTX 4090)
- **Scale**: 750-850 GB/s
- **Add**: 750-850 GB/s  
- **Triad**: 750-850 GB/s

### HPCG (Sparse Linear Algebra)
- **GFLOPS**: 100-200 (depends on problem size)
- **Efficiency**: 15-25% of peak theoretical

### Mini-MLPerf (ML Workloads)
- **NumPy baseline**: 0.5-2.0s per inference
- **ResNet-50 simulation**: 1.0-3.0s per batch
- **BERT tiny simulation**: 0.8-2.5s per sequence

*Note: Results vary significantly based on GPU model, memory, and thermal conditions.*

## Troubleshooting

### Docker Permission Issues
```bash
# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

### GPU Not Detected
```bash
# Install NVIDIA Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://nvidia.github.io/libnvidia-container/stable/deb/$(. /etc/os-release;echo $ID$VERSION_ID) /" | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

### Signature Verification Fails
```bash
# Check file integrity first
sha256sum -c manifest.sha256

# Regenerate Ed25519 keys if needed
rm -rf ~/.scu/ed25519_*
./scripts/ed25519_sign.sh auto  # Will create new keys
```

### Low Performance Results
- Check GPU thermal throttling: `nvidia-smi`
- Ensure exclusive GPU access (close other GPU applications)
- Verify sufficient cooling and power supply

## Validation Checklist

- [ ] All three benchmark JSONs generated
- [ ] SHA256 checksums verify: `sha256sum -c manifest.sha256`
- [ ] Ed25519 signature verifies: `./scripts/ed25519_verify.sh auto`
- [ ] GPU telemetry captured in CSV files
- [ ] Results within expected performance ranges
- [ ] No error messages in console output

## Automated Verification (CI/CD)

For continuous integration, use the quick test mode:

```yaml
# GitHub Actions example
- name: Run SCU benchmarks
  run: bash benchmarks/run_all_direct.sh --quick_test
  
- name: Verify cryptographic signatures
  run: |
    ./scripts/ed25519_verify.sh auto
    if [ $? -ne 0 ]; then
      echo "❌ Signature verification failed"
      exit 1
    fi
    echo "✅ Benchmark results verified"
```

## Contact & Support

- **Issues**: [GitHub Issues](https://github.com/SymmetricResearch/scu-benchmarks/issues)
- **Security**: For cryptographic verification questions
- **Performance**: For benchmark result validation

For external audit requests, include:
1. Your hardware specification
2. Complete console output
3. Generated `results/` directory
4. Verification script output