FROM nvidia/cuda:12.2-runtime-ubuntu22.04

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bc \
    && rm -rf /var/lib/apt/lists/*

# Create output directory
RUN mkdir -p /output

# Copy run script
COPY run_hpcg.sh /run_hpcg.sh
RUN chmod +x /run_hpcg.sh

ENTRYPOINT ["/run_hpcg.sh"]