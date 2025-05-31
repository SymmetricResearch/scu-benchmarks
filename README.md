# SCU Benchmarks

Standard Compute Unit (SCU) benchmark suite with cryptographic result verification.

## Features

- **Multi-benchmark suite**: STREAM, HPCG, Mini-MLPerf
- **Dual signing**: SHA256 checksums + Ed25519 digital signatures  
- **Self-hosted GPU runners**: Nightly automated benchmarks
- **Cost tracking**: Automated cost reporting per benchmark run

## Quick Start

```bash
# Run full benchmark suite
bash benchmarks/run_all_direct.sh --full

# Sign results with Ed25519 (auto-detects latest results)
./scripts/ed25519_sign.sh auto

# Verify signatures
./scripts/ed25519_verify.sh auto [public_key.pub]
```

## Security

Benchmark results include dual verification:
- **SHA256 manifest**: File integrity checksums
- **Ed25519 signature**: Cryptographic authenticity proof

Ed25519 keys are auto-generated in `~/.scu/` on first use.
