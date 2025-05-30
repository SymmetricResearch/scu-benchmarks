# Benchmark Runners

This directory contains standardized benchmark runners for SCU measurement and analysis.

## Available Runners

### MLPerf Runner (`mlperf/runner.py`)
Dry-run implementation of MLPerf benchmarks with SCU estimation.

**Supported Benchmarks:**
- ResNet (image classification)
- BERT (natural language processing)
- DLRM (recommendation systems)
- 3D-UNet (medical imaging)
- RNN-T (speech recognition)
- RetinaNet, MaskRCNN, SSD (object detection)
- MiniGo (reinforcement learning)

**Usage:**
```bash
# Run single benchmark
python runners/mlperf/runner.py resnet

# Run benchmark suite
python runners/mlperf/runner.py suite

# Run with config
python runners/mlperf/runner.py bert config.json
```

### STREAM Runner (`stream/runner.py`)
Memory bandwidth benchmark with SCU correlation.

**Operations:**
- Copy: `a[i] = b[i]`
- Scale: `a[i] = q * b[i]`
- Add: `a[i] = b[i] + c[i]`
- Triad: `a[i] = b[i] + q * c[i]`

**Usage:**
```bash
# Run single operation
python runners/stream/runner.py copy

# Run full suite
python runners/stream/runner.py suite

# Custom array size
python runners/stream/runner.py suite 50000000
```

## Output Format

Both runners provide structured output with SCU estimates:

```json
{
  "benchmark_name": "resnet",
  "execution_time": 0.105,
  "throughput": 1250.5,
  "scu_estimate": 0.131,
  "metadata": {
    "mode": "dry-run",
    "timestamp": 1234567890.0
  }
}
```

## Integration Notes

- All runners are currently in **dry-run mode** for development
- SCU estimates use placeholder calculations
- Results include metadata for analysis pipeline integration
- Runners support JSON configuration for parameterization