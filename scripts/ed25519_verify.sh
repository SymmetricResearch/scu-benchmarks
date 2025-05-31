#!/bin/bash
# ed25519_verify.sh - Verify Ed25519 signatures for SCU benchmark artifacts
# Usage: ./scripts/ed25519_verify.sh [results_dir] [public_key_path]

set -euo pipefail

RESULTS_DIR=${1:-}
PUBLIC_KEY=${2:-~/.scu/ed25519_private.pub}

# Auto-detect latest results directory if not specified
if [[ -z "$RESULTS_DIR" || "$RESULTS_DIR" == "auto" ]]; then
  RESULTS_DIR=$(ls -d results/*/ 2>/dev/null | sort -Vr | head -n1)
fi

if [[ -z "$RESULTS_DIR" || ! -d "$RESULTS_DIR" ]]; then
  echo "❌ No results directory found"
  exit 1
fi

echo "🔍 Verifying Ed25519 signatures in $RESULTS_DIR"

# Check for required files
REQUIRED_FILES=(
  "$RESULTS_DIR/manifest.sha256"
  "$RESULTS_DIR/signature_metadata.txt"
  "$RESULTS_DIR/signature.ed25519"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "❌ Missing required file: $(basename "$file")"
    exit 1
  fi
done

# Check for public key
if [[ ! -f "$PUBLIC_KEY" ]]; then
    echo "❌ Public key not found: $PUBLIC_KEY"
    echo "💡 Please provide the public key path or ensure it exists at default location"
    exit 1
fi

# Check for required tools
if ! command -v openssl &> /dev/null; then
    echo "❌ OpenSSL not found. Please install OpenSSL to verify Ed25519 signatures."
    exit 1
fi

# Verify the Ed25519 signature
echo "🔐 Verifying Ed25519 signature..."
if ssh-keygen -Y verify -f "$PUBLIC_KEY" -n file -s "$RESULTS_DIR/signature.ed25519" -I file < "$RESULTS_DIR/signature_metadata.txt"
    echo "✅ Ed25519 signature verification: PASSED"
    SIGNATURE_VALID=true
else
    echo "❌ Ed25519 signature verification: FAILED"
    SIGNATURE_VALID=false
fi

# Verify manifest integrity
echo "📝 Verifying artifact manifest..."
MANIFEST_ERRORS=0

while IFS= read -r line; do
    EXPECTED_HASH=$(echo "$line" | cut -d' ' -f1)
    FILE_PATH=$(echo "$line" | cut -d' ' -f3-)
    
    if [[ -f "$FILE_PATH" ]]; then
        ACTUAL_HASH=$(sha256sum "$FILE_PATH" | cut -d' ' -f1)
        if [[ "$EXPECTED_HASH" != "$ACTUAL_HASH" ]]; then
            echo "❌ Hash mismatch: $(basename "$FILE_PATH")"
            ((MANIFEST_ERRORS++))
        fi
    else
        echo "❌ Missing file: $(basename "$FILE_PATH")"
        ((MANIFEST_ERRORS++))
    fi
done < "$RESULTS_DIR/manifest.sha256"

if [[ $MANIFEST_ERRORS -eq 0 ]]; then
    echo "✅ Manifest verification: PASSED ($(wc -l < "$RESULTS_DIR/manifest.sha256") files)"
    MANIFEST_VALID=true
else
    echo "❌ Manifest verification: FAILED ($MANIFEST_ERRORS errors)"
    MANIFEST_VALID=false
fi

# Display signature metadata
echo ""
echo "📋 Signature Metadata:"
echo "====================="
cat "$RESULTS_DIR/signature_metadata.txt" | grep -E "(Generated|Signer|Hardware|GPU|Benchmark)"

# Display public key info
echo ""
echo "🔑 Public Key Info:"
echo "=================="
echo "Fingerprint: $(openssl pkey -pubin -in "$PUBLIC_KEY" | openssl dgst -sha256 | cut -d' ' -f2)"
echo "Key file: $PUBLIC_KEY"

# Final verification result
echo ""
echo "🏆 VERIFICATION SUMMARY:"
echo "======================="
if [[ "$SIGNATURE_VALID" == true && "$MANIFEST_VALID" == true ]]; then
    echo "✅ ALL CHECKS PASSED - Artifacts are authentic and unmodified"
    exit 0
else
    echo "❌ VERIFICATION FAILED - Do not trust these artifacts"
    exit 1
fi