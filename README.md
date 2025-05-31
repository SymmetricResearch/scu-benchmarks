# SCU Benchmarks

Standard Compute Unit (SCU) benchmark suite with enhanced ML models and cryptographic result verification.

## Features

- **Enhanced ML suite**: STREAM, HPCG, Mini-MLPerf (baseline + ResNet-50 + BERT tiny)
- **Dual signing**: SHA256 checksums + Ed25519 digital signatures  
- **Self-hosted GPU runners**: Nightly automated benchmarks
- **Cost tracking**: Automated cost reporting per benchmark run
- **Flexible modes**: Quick test for CI, full suite for validation

## Quick Start

```bash
# Run full benchmark suite (all models)
bash benchmarks/run_all_direct.sh --full

# Run quick test (baseline models only, ~30s faster)
bash benchmarks/run_all_direct.sh --quick_test

# Sign results with Ed25519 (auto-detects latest results)
./scripts/ed25519_sign.sh auto

# Verify signatures
./scripts/ed25519_verify.sh auto [public_key.pub]
```

## Benchmark Modes

| Mode | Command | Models | Runtime | Use Case |
|------|---------|--------|---------|----------|
| Standard | ` ` | STREAM + HPCG | ~5 min | Basic benchmarking |
| Quick | `--quick_test` | + MLPerf baseline | ~5.5 min | CI/development |
| Full | `--full` | + ResNet-50 + BERT tiny | ~8 min | Nightly validation |
## Security

Benchmark results include dual verification:
- **SHA256 manifest**: File integrity checksums
- **Ed25519 signature**: Cryptographic authenticity proof

Ed25519 keys are auto-generated in `~/.scu/` on first use.

## ML Models (C-1b Enhancement)

Enhanced Mini-MLPerf suite includes:
- **NumPy baseline**: Dense matrix operations (40% weight)
- **ResNet-50 simulation**: Computer vision workload (35% weight)  
- **BERT tiny simulation**: NLP transformer attention (25% weight)

See [docs/C-1b-extra-models.md](docs/C-1b-extra-models.md) for implementation details.
