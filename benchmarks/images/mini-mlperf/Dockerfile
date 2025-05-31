FROM nvidia/cuda:12.0-devel-ubuntu22.04

# Install Python and dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install PyTorch and other ML dependencies
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN pip3 install numpy tensorflow

# Create a simple ML benchmark
WORKDIR /app
COPY mini_mlperf.py /app/
COPY run_mlperf.sh /run_mlperf.sh
RUN chmod +x /run_mlperf.sh

# Create output directory
RUN mkdir -p /output

ENTRYPOINT ["/run_mlperf.sh"]