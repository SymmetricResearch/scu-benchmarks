#!/usr/bin/env bash

echo "=== SCU Local Runner Cost Report ==="
echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

echo "Local runner GPU power (current):"
if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits | \
    awk '{sum+=$1} END{printf "%.1f W\n", sum}'
    
    TOTAL_WATTS=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits | awk '{sum+=$1} END{print sum}')
    DAILY_KWH=$(echo "$TOTAL_WATTS" | awk '{printf "%.2f", $1*24/1000}')
    MONTHLY_KWH=$(echo "$DAILY_KWH" | awk '{printf "%.1f", $1*30}')
    
    echo "Estimated daily energy: ${DAILY_KWH} kWh"
    echo "Estimated monthly energy: ${MONTHLY_KWH} kWh"
    echo "Estimated monthly cost (@ $0.12/kWh): \$$(echo "$MONTHLY_KWH" | awk '{printf "%.2f", $1*0.12}')"
else
    echo "nvidia-smi not available"
fi

echo ""
echo "Hardware: 2x RTX 3080, Local Runner scu-local-3080"
echo "CI Cost: $0/month (local hardware only)"