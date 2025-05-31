# SCU Benchmarks Roadmap v0.5

## ✔️ Done

- **E-3b**: Enhanced container build reliability with ubuntu:22.04 base images
- **F-3**: Full benchmark suite integration (STREAM, HPCG, Mini-MLPerf)
- **F-2**: Local GPU runner implementation with artifact signing
- **G-1b**: Automated cost reporting for benchmark runs

## 🚧 In Progress

- **C-1b**: Add two additional Mini-MLPerf models
  - Status: Planning phase
  - Priority: Medium
  - Dependencies: Core Mini-MLPerf infrastructure

## 📋 Planned

- **E-5**: Implement Ed25519 signing for artifacts
  - Status: Not started
  - Priority: High
  - Dependencies: Artifact generation pipeline

## 🎯 Key Objectives

1. **Benchmark Coverage**: Expand model diversity in Mini-MLPerf suite
2. **Security**: Enhanced cryptographic signing for result integrity
3. **Reliability**: Continued infrastructure stability improvements

## Notes

- All benchmarks run on self-hosted GPU runners
- Artifact signing currently uses SHA256 checksums
- CI pipeline includes nightly full benchmark runs