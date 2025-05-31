FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential \
    openmpi-bin \
    libopenmpi-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# TODO: download HPCG source & compile
# WORKDIR /opt
# RUN wget https://www.hpcg-benchmark.org/downloads/hpcg-3.1.tar.gz \
#     && tar -xzf hpcg-3.1.tar.gz \
#     && cd hpcg-3.1 \
#     && make arch=Linux_MPI

CMD ["bash", "-c", "echo 'TODO: run HPCG benchmark'"]