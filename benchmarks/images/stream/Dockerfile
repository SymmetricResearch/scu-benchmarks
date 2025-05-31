FROM ubuntu:22.04

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download and compile STREAM benchmark
WORKDIR /app
RUN wget -O stream.c https://raw.githubusercontent.com/jeffhammond/STREAM/master/stream.c
RUN gcc -O3 -fopenmp -DSTREAM_ARRAY_SIZE=80000000 -DNTIMES=100 stream.c -o stream

# Create output directory
RUN mkdir -p /output

# Copy run script
COPY run_stream.sh /run_stream.sh
RUN chmod +x /run_stream.sh

ENTRYPOINT ["/run_stream.sh"]