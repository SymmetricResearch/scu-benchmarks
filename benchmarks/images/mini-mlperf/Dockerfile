FROM nvidia/cuda:12.2-runtime-ubuntu22.04

# Install Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    bc \
    && rm -rf /var/lib/apt/lists/*

# Install minimal Python packages
RUN pip3 install numpy

# Create a simple ML benchmark
WORKDIR /app
COPY mini_mlperf.py /app/
COPY run_mlperf.sh /run_mlperf.sh
RUN chmod +x /run_mlperf.sh

# Create output directory
RUN mkdir -p /output

ENTRYPOINT ["/run_mlperf.sh"]