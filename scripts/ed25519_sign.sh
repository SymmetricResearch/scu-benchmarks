#!/bin/bash
# ed25519_sign.sh - Ed25519 digital signature for SCU benchmark artifacts
# Usage: ./scripts/ed25519_sign.sh [results_dir] [private_key_path]

set -euo pipefail

RESULTS_DIR=${1:-}
PRIVATE_KEY=${2:-~/.scu/ed25519_private}

# Auto-detect latest results directory if not specified
if [[ -z "$RESULTS_DIR" || "$RESULTS_DIR" == "auto" ]]; then
  RESULTS_DIR=$(ls -d results/*/ 2>/dev/null | sort -Vr | head -n1)
fi

if [[ -z "$RESULTS_DIR" || ! -d "$RESULTS_DIR" ]]; then
  echo "❌ No results directory found – aborting signing"
  exit 1
fi

echo "🔐 Ed25519 signing artifacts in $RESULTS_DIR"

# Check for required tools
if ! command -v openssl &> /dev/null; then
    echo "❌ OpenSSL not found. Please install OpenSSL to use Ed25519 signing."
    exit 1
fi

# Generate key pair if private key doesn't exist
if [[ ! -f "$PRIVATE_KEY" ]]; then
    echo "🔑 Generating Ed25519 key pair..."
    mkdir -p "$(dirname "$PRIVATE_KEY")"
    
    # Generate SSH Ed25519 key pair
    ssh-keygen -t ed25519 -f "$PRIVATE_KEY" -N "" -C "SCU-benchmark-signing"
    
    # Public key is automatically created as .pub
    PUBLIC_KEY="${PRIVATE_KEY}.pub"
    
    echo "✅ Key pair generated:"
    echo "   Private: $PRIVATE_KEY"
    echo "   Public:  $PUBLIC_KEY"
    echo "⚠️  Keep private key secure and share public key for verification"
fi

# Create SHA256 manifest of all files
echo "📝 Creating artifact manifest..."
find "$RESULTS_DIR" -type f -not -name "*.sig" -not -name "manifest.*" -exec sha256sum {} \; | sort > "$RESULTS_DIR/manifest.sha256"

# Create metadata for signing
METADATA_FILE="$RESULTS_DIR/signature_metadata.txt"
cat > "$METADATA_FILE" << EOF
SCU Benchmark Signature Metadata
Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Signer: $(whoami)@$(hostname)
Hardware: $(lscpu | grep "Model name" | cut -d: -f2 | xargs)
GPU: $(nvidia-smi --query-gpu=name --format=csv,noheader,nounits 2>/dev/null | head -1 || echo "No GPU detected")
Benchmark Suite: SCU Full Benchmark v$(date +%Y.%m)
Results Directory: $(basename "$RESULTS_DIR")
Manifest SHA256: $(sha256sum "$RESULTS_DIR/manifest.sha256" | cut -d' ' -f1)
EOF

# Sign the metadata file with Ed25519
echo "🖊️  Signing with Ed25519..."
ssh-keygen -Y sign -f "$PRIVATE_KEY" -n file - < "$METADATA_FILE" > "$RESULTS_DIR/signature.ed25519"

# Create human-readable signature info
SIGNATURE_INFO="$RESULTS_DIR/signature_info.txt"
cat > "$SIGNATURE_INFO" << EOF
SCU Benchmark Ed25519 Signature
===============================

Signature Algorithm: Ed25519
Signed: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Public Key Fingerprint: $(ssh-keygen -lf "${PRIVATE_KEY}.pub" | cut -d' ' -f2)

Verification Command:
ssh-keygen -Y verify -f [public_key.pub] -n file -s signature.ed25519 -I file < signature_metadata.txt

Files included in manifest: $(wc -l < "$RESULTS_DIR/manifest.sha256") files
Total manifest checksum: $(sha256sum "$RESULTS_DIR/manifest.sha256" | cut -d' ' -f1)
EOF

echo "✅ Ed25519 signature complete!"
echo "📁 Signed artifacts:"
echo "   • manifest.sha256 - File checksums"
echo "   • signature_metadata.txt - Signed metadata"  
echo "   • signature.ed25519 - Ed25519 signature"
echo "   • signature_info.txt - Human-readable info"
echo ""
echo "🔍 Verify with: ./scripts/ed25519_verify.sh $RESULTS_DIR"