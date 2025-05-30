# EXP-20250517-IA1 v1.4-20250512
## Experiment Version Information
- Date: 2025-05-12
- Version: 1.4.0
- Sample Size: 75% (Comprehensive Analysis with Enhanced Reporting)
- Phases Completed: 1, 2, 3, 4, 5 (Cross-Analysis with Full Data Processing)

## Description
This version represents a major enhancement to the EXP-20250517-IA1 pipeline with proper implementation
of all parsers (Azure Native GPU, JSSP, Star Job, Mega Math) and comprehensive data analysis without
VRAM filtering restrictions. The experiment analyzes all workloads to generate accurate cross-analysis
results and produces enhanced reporting with visualization and literature integration.

## Major Improvements
1. **Comprehensive Data Analysis**:
   - Analysis of all workloads regardless of hardware requirements
   - Complete processing of high-end GPU workloads (A100, V100)
   - Enhanced statistical analysis of all workload types

2. **Enhanced Reporting**:
   - Comprehensive visualizations for all analysis components
   - Integration with academic literature via OpenAlex
   - Detailed cross-analysis with provider rankings and arbitrage detection

3. **Parser Improvements**:
   - Further enhanced specialized workload parsers
   - Better error handling and format detection
   - Improved data validation for all workload types

## Changes from v1.3
- Removed VRAM filtering constraint to analyze all workloads
- Implemented enhanced reporting framework
- Added academic literature integration
- Expanded cross-analysis with more detailed insights

## Dataset Mapping
| Dataset ID | Source | Description |
|------------|--------|-------------|
| azure_native_gpu | Azure VM traces | GPU workloads from Azure native monitoring |
| jssp | Job Shop Scheduling | Job shop scheduling problem workloads |
| star_job | HPC | HPC star job workloads with resource matching |
| mega_math | Mathematical Computing | Computational mathematics workloads |
| alibaba_gpu2020 | Alibaba Traces 2020 | GPU trace data from Alibaba 2020 dataset |
| alibaba_gpu2025 | Alibaba Traces 2025 | GPU trace data from Alibaba 2025 dataset |
| alibaba2018 | Alibaba 2018 | Container workload data from Alibaba 2018 dataset |

## Price Feed Details
| Provider | Date Range | Points | Update Frequency |
|----------|------------|--------|------------------|
| aws | 2024-01 to 2025-05 | 1800+ | Hourly |
| azure | 2024-01 to 2025-05 | 1800+ | Hourly |
| oci | 2024-01 to 2025-05 | 1900+ | Hourly |
| coreweave | 2024-01 to 2025-05 | 1900+ | Hourly |
| hetzner | 2024-01 to 2025-05 | 1800+ | Hourly |
| nebius | 2024-01 to 2025-05 | 1900+ | Hourly |
| linode | 2024-01 to 2025-05 | 1400+ | Hourly |

Generated: 2025-05-12 14:40:00
