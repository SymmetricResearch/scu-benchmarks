# C-1b: Extra Mini-MLPerf Models Implementation

This document describes the implementation of additional ML models for improved benchmark representativeness.

## Overview

Roadmap item C-1b adds two additional Mini-MLPerf models to improve ML representativeness:
- **ResNet-50**: Computer vision inference simulation  
- **BERT tiny**: Natural language processing inference simulation

## Models Included

### 1. Baseline: NumPy Matrix Multiplication
- **Purpose**: Baseline computational performance
- **Characteristics**: Dense linear algebra operations
- **Metrics**: GFLOPS via matrix multiplication

### 2. ResNet-50 Inference Simulation  
- **Purpose**: Computer vision workload representation
- **Characteristics**: Convolutional neural network simulation
- **Parameters**: ~25M parameter model, 224x224 input images
- **Metrics**: Estimated 4.1 GFLOPs per image

### 3. BERT Tiny Inference Simulation
- **Purpose**: Natural language processing workload representation  
- **Characteristics**: Transformer attention mechanism simulation
- **Parameters**: 2 layers, 128 hidden size, 128 sequence length
- **Metrics**: Estimated 0.1 GFLOPs per sequence

## Usage

### Quick Test Mode (CI/Development)
```bash
# Run only baseline model (~30 seconds)
bash benchmarks/run_all_direct.sh --quick_test
```

### Full Suite Mode (Nightly)
```bash
# Run all models including ResNet-50 and BERT tiny (~3 minutes additional)
bash benchmarks/run_all_direct.sh --full
```

### Standard Mode
```bash
# Run STREAM + HPCG only (no MLPerf)
bash benchmarks/run_all_direct.sh
```

## Implementation Details

### Enhanced MLPerf Runner
- **File**: `benchmarks/images/mini-mlperf/enhanced_mlperf.py`
- **Features**: 
  - Composite SCU scoring across model types
  - Weighted performance calculation
  - NumPy-based model simulation for broad compatibility

### Composite Scoring
The composite SCU score weights different model types:
- NumPy baseline: 40% (general compute)
- ResNet-50: 35% (computer vision) 
- BERT tiny: 25% (natural language processing)

### Docker Integration
- Models run in existing `scu-mini-mlperf:latest` container
- Backward compatible with existing workflows
- Optional `--quick_test` flag for CI environments

## Performance Impact

| Mode | Models | Estimated Runtime | Use Case |
|------|--------|------------------|----------|
| Standard | STREAM + HPCG | ~5 minutes | Basic benchmarking |
| Quick Test | + MLPerf baseline | ~5.5 minutes | CI/development |
| Full Suite | + ResNet-50 + BERT | ~8 minutes | Nightly/validation |

## Licensing

All model simulations use NumPy operations without external model weights:
- No pre-trained model dependencies
- No licensing concerns for ONNX weights
- Pure mathematical simulation approach

## Future Enhancements

- Real ONNX Runtime integration (requires model weights licensing review)
- GPU acceleration for simulation workloads
- Additional model architectures (Vision Transformer, GPT variants)