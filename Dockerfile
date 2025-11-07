FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libgl1 \
        libglib2.0-0 \
        libsm6 \
        libxrender1 \
        libxext6 \
        ffmpeg \
        wget \
        git \
        ca-certificates \
        ninja-build \
        vim \
        curl \
        iputils-ping \
        dnsutils \
        procps \
        htop \
        lsof \
        net-tools \
        tree \
        unzip \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -U pip setuptools wheel && \
    pip install --no-cache-dir "packaging>=22.0"

RUN pip install --no-cache-dir \
    torch==2.6.0 torchvision torchaudio xformers==0.0.29.post2 \
    --index-url https://download.pytorch.org/whl/cu124

WORKDIR /app

RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git ComfyUI

COPY install_custom_nodes.sh /app/install_custom_nodes.sh

RUN chmod +x /app/install_custom_nodes.sh && \
    /app/install_custom_nodes.sh

RUN pip install --no-cache-dir -r /app/ComfyUI/requirements.txt

EXPOSE 8188

ENV EXTRA_ARGS=""

CMD ["sh", "-c", "python ComfyUI/main.py --listen 0.0.0.0 --port 8188 $EXTRA_ARGS"]