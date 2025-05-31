#!/bin/bash
# collect_gpu_stats.sh - Capture GPU telemetry for SCU benchmark validation
# Usage: ./collect_gpu_stats.sh [output_file]

set -euo pipefail

OUTPUT_FILE="${1:-gpu_stats.csv}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Collecting GPU telemetry at $TIMESTAMP..."

# Check if nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    echo "Warning: nvidia-smi not found. Creating placeholder file."
    echo "timestamp,error" > "$OUTPUT_FILE"
    echo "$TIMESTAMP,nvidia-smi not available" >> "$OUTPUT_FILE"
    exit 0
fi

# Create CSV header
echo "timestamp,gpu_id,name,memory_total,memory_used,memory_free,utilization_gpu,utilization_memory,temperature,power_draw,power_limit" > "$OUTPUT_FILE"

# Query GPU stats in CSV format
nvidia-smi --query-gpu=index,name,memory.total,memory.used,memory.free,utilization.gpu,utilization.memory,temperature.gpu,power.draw,power.limit \
    --format=csv,noheader,nounits | while IFS=',' read -r gpu_id name mem_total mem_used mem_free util_gpu util_mem temp power_draw power_limit; do
    
    # Clean up whitespace
    gpu_id=$(echo "$gpu_id" | xargs)
    name=$(echo "$name" | xargs)
    mem_total=$(echo "$mem_total" | xargs)
    mem_used=$(echo "$mem_used" | xargs)
    mem_free=$(echo "$mem_free" | xargs)
    util_gpu=$(echo "$util_gpu" | xargs)
    util_mem=$(echo "$util_mem" | xargs)
    temp=$(echo "$temp" | xargs)
    power_draw=$(echo "$power_draw" | xargs)
    power_limit=$(echo "$power_limit" | xargs)
    
    echo "$TIMESTAMP,$gpu_id,$name,$mem_total,$mem_used,$mem_free,$util_gpu,$util_mem,$temp,$power_draw,$power_limit" >> "$OUTPUT_FILE"
done

echo "GPU stats saved to $OUTPUT_FILE"

# Also create a JSON version for structured consumption
JSON_FILE="${OUTPUT_FILE%.csv}.json"
nvidia-smi -q -x > "$JSON_FILE" 2>/dev/null || echo '{"error": "nvidia-smi XML query failed"}' > "$JSON_FILE"

echo "GPU XML data saved to $JSON_FILE"