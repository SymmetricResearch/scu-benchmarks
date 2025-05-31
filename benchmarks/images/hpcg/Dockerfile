FROM nvidia/cuda:12.0-devel-ubuntu22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    wget \
    mpich \
    libmpich-dev \
    && rm -rf /var/lib/apt/lists/*

# Download and build HPCG
WORKDIR /app
RUN wget -O hpcg-3.1.tar.gz https://github.com/hpcg-benchmark/hpcg/archive/3.1.tar.gz
RUN tar -xzf hpcg-3.1.tar.gz
WORKDIR /app/hpcg-3.1

# Configure and build HPCG for CUDA
COPY Make.Linux_CUDA /app/hpcg-3.1/setup/
RUN mkdir -p build && cd build && \
    ../configure Linux_CUDA && \
    make

# Create output directory
RUN mkdir -p /output

# Copy run script
COPY run_hpcg.sh /run_hpcg.sh
RUN chmod +x /run_hpcg.sh

ENTRYPOINT ["/run_hpcg.sh"]