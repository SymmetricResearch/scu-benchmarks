#!/bin/bash

set -e

echo "Setting up GitHub Actions Runner for scu-benchmarks"

# Check if required environment variables are set
if [ -z "$RUNNER_TOKEN" ]; then
    echo "ERROR: RUNNER_TOKEN environment variable not set"
    echo "Please generate a runner token at:"
    echo "https://github.com/SymmetricResearch/scu-benchmarks/settings/actions/runners"
    exit 1
fi

if [ -z "$REPO_URL" ]; then
    export REPO_URL="https://github.com/SymmetricResearch/scu-benchmarks"
fi

# Set up runner in home directory
RUNNER_DIR="$HOME/actions-runner"

if [ ! -d "$RUNNER_DIR" ]; then
    echo "Creating runner directory..."
    mkdir -p "$RUNNER_DIR"
    cd "$RUNNER_DIR"
    
    # Download runner if not already present
    if [ ! -f "run.sh" ]; then
        echo "Downloading GitHub Actions runner..."
        curl -o actions-runner-linux-x64-2.321.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-x64-2.321.0.tar.gz
        tar xzf actions-runner-linux-x64-2.321.0.tar.gz
        rm actions-runner-linux-x64-2.321.0.tar.gz
    fi
else
    cd "$RUNNER_DIR"
fi

# Configure runner
echo "Configuring runner..."
./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --name "scu-local-3080" --labels "self-hosted,scu-ci,gpu" --unattended

# Install as service
echo "Installing runner as service..."
sudo ./svc.sh install
sudo ./svc.sh start

echo "Runner setup complete!"
echo "Check status with: sudo ./svc.sh status"
echo "View logs with: sudo journalctl -u actions.runner.SymmetricResearch-scu-benchmarks.scu-local-3080.service -f"