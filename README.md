# ComfyUI Docker Build

English / [简体中文](./README_ZH.md)

A pre-configured ComfyUI Docker image with PyTorch CUDA 13.0 support and multiple popular custom nodes.

## Required NVIDIA Container Runtime Setup

On a Linux host with an NVIDIA GPU, install and configure NVIDIA Container Toolkit before building or starting this project. Docker cannot pass the GPU into the container without this runtime, and commands that use `--gpus all` will fail.

For Ubuntu/Debian, run:

```bash
# Install nvidia-container-toolkit
sudo apt-get install -y nvidia-container-toolkit

# Configure Docker to use the NVIDIA runtime
sudo nvidia-ctk runtime configure --runtime=docker

# Restart Docker to apply the configuration
sudo systemctl restart docker
```

This assumes Docker, the NVIDIA driver, and the NVIDIA Container Toolkit package repository are already available on the host. Complete this step before using either `docker compose` or `docker run` below.

## Current ComfyUI Environment Requirements

According to the upstream ComfyUI README:

- PyTorch 2.7 is only minimally supported; a newer version is strongly recommended. PyTorch installations older than six months should be upgraded.
- NVIDIA 20-series and newer GPUs require a CUDA 13.0 or newer PyTorch build.
- Python 3.13 is well supported, with Python 3.12 recommended when custom-node dependencies have issues. This image uses Python 3.12.
- This image uses the verified `torch==2.13.0` and `xformers==0.0.35` combination. Pip resolves matching `torchvision` and `torchaudio` versions for that Torch release.

The build defaults to the current stable ComfyUI release, `v0.34.6`, instead of `master`. Upstream warns that unreleased `master` commits can break many custom nodes. Override the `COMFYUI_REF` build argument to test another release.

To move to a newer stable tag, for example `v0.35.0`:

```bash
COMFYUI_REF=v0.35.0 docker compose build --no-cache
docker compose up -d
```

## 📦 Included Custom Nodes

This project comes pre-installed with the following custom nodes:

- ComfyUI-Manager
- ComfyUI-Light-Tool
- ComfyUI-Crystools
- rgthree-comfy
- ComfyUI_LayerStyle
- ComfyUI-Easy-Use
- ComfyUI-KJNodes
- ComfyUI-WD14-Tagger
- ComfyUI_IPAdapter_plus
- ComfyUI-Custom-Scripts
- ComfyMath
- ComfyUI-BrushNet
- ComfyUI-Impact-Pack
- comfyui_controlnet_aux
- ComfyUI-Florence2
- efficiency-nodes-comfyui
- ComfyUI-Inspire-Pack
- ComfyUI-SUPIR
- ComfyUI_InstantID
- ComfyUI-IC-Light
- ComfyUI_essentials
- comfyui-various
- comfyui-mixlab-nodes
- ComfyUI_Comfyroll_CustomNodes
- Comfyui_TTP_Toolset

And more...

## 🛠️ Building the Image

### Local Build

```bash
docker build -t comfyui-full:gpu-cu130 .
```

The recommended path is to build and start with Compose:

```bash
docker compose build --no-cache
docker compose up -d
docker compose logs -f comfyui
```

NVIDIA 10-series and older GPUs cannot use CUDA 13.0. Build with the upstream CUDA 12.6 compatibility option instead:

```bash
PYTORCH_INDEX_URL=https://download.pytorch.org/whl/cu126 docker compose build --no-cache
```

## 📥 Pull from Docker Hub

You can also pull the pre-built image directly from Docker Hub without local building:

```bash
docker pull ihmily/comfyui-full:gpu-cu130
```

## 🚀 Running the Container

The following examples use the locally built `comfyui-full:gpu-cu130` image.

### Basic Run Command

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  comfyui-full:gpu-cu130
```

### Recommended Run Configuration

##### Mount related directories

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v "$HOME/.cache/huggingface/hub:/root/.cache/huggingface/hub" \
  -v "$HOME/.cache/torch/hub:/root/.cache/torch/hub" \
  -v "$PWD/models:/app/ComfyUI/models" \
  -v "$PWD/user:/app/ComfyUI/user" \
  -v "$PWD/output:/app/ComfyUI/output" \
  -v "$PWD/input:/app/ComfyUI/input" \
  comfyui-full:gpu-cu130
```

To more conveniently manage custom nodes, you can mount the custom_nodes directory. Note that if the local custom_nodes directory is empty after mounting, there will be no ComfyUI nodes in the container.

##### Mount related directories (complete)

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v "$HOME/.cache/huggingface/hub:/root/.cache/huggingface/hub" \
  -v "$HOME/.cache/torch/hub:/root/.cache/torch/hub" \
  -v "$PWD/models:/app/ComfyUI/models" \
  -v "$PWD/user:/app/ComfyUI/user" \
  -v "$PWD/output:/app/ComfyUI/output" \
  -v "$PWD/input:/app/ComfyUI/input" \
  -v "$PWD/custom_nodes:/app/ComfyUI/custom_nodes" \
  comfyui-full:gpu-cu130
```

For users in China who have poor network access to HuggingFace, you can configure a HuggingFace mirror environment variable by adding the following parameter when running the container:

```bash
-e HF_ENDPOINT="https://hf-mirror.com"
```

All the above run configurations can be modified according to your actual needs.

### Adding ComfyUI Startup Parameters (Optional)

#### Method 1: Direct Command Override

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  comfyui-full:gpu-cu130 \
  python ComfyUI/main.py --listen 0.0.0.0 --port 8188 --disable-metadata --disable-smart-memory --cuda-device 0
```

#### Method 2: Using Environment Variables

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e EXTRA_ARGS="--cuda-device 0 --disable-metadata --disable-smart-memory" \
  comfyui-full:gpu-cu130
```

#### Common Startup Parameters

- `--cuda-device 0`  - Select GPU cuda device, for example that use cuda:0 
- `--disable-metadata` - Disable metadata
- `--disable-smart-memory` - Disable smart memory management
- `--cpu` - Force CPU usage
- `--lowvram` - Low VRAM mode
- `--normalvram` - Normal VRAM mode
- `--highvram` - High VRAM mode
- `--gpu-memory-fraction 0.8` - Set GPU memory usage to 80%
- `--force-fp16` - Force FP16 precision
- `--force-fp32` - Force FP32 precision

## 📁 Directory Mounting

| Container Path | Recommended Mount Path | Description |
|----------------|------------------------|-------------|
| `/app/ComfyUI/models` | `/path/to/models` | Model files directory |
| `/app/ComfyUI/custom_nodes` | `/path/to/custom_nodes` | Custom nodes directory |
| `/app/ComfyUI/output` | `/path/to/output` | Output files directory |
| `/app/ComfyUI/input` | `/path/to/input` | Input files directory |
| `/app/ComfyUI/user` | `/path/to/user` | User directory (stores workflow files) |
| `/root/.cache/huggingface/hub` | `/$HOME/.cache/huggingface/hub` | HuggingFace cache directory |
| `/root/.cache/torch/hub` | `/$HOME/.cache/torch/hub` | Torch cache directory |

## 🔧 Environment Variables

- `EXTRA_ARGS`: Append ComfyUI startup arguments; select a device with `--cuda-device 0`
- `HF_ENDPOINT`: HuggingFace mirror service for Chinese users

The `COMFYUI_REF` build argument selects a stable ComfyUI tag, while `PYTORCH_INDEX_URL` selects the PyTorch CUDA package index.

## 🌐 Accessing ComfyUI

After starting the container, access ComfyUI in your browser at:

```
http://localhost:8188
```

## 📋 System Requirements

- **Docker**: Version 20.10 or higher
- **NVIDIA Docker**: Docker runtime with GPU support
- **GPU**: NVIDIA 20-series and newer use CUDA 13.0; 10-series and older use the CUDA 12.6 compatibility build
- **Memory**: At least 8GB RAM recommended
- **Storage**: At least 20GB free space recommended

## 🐛 Troubleshooting

### 1. GPU Not Available

If you get the error: docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]].

Execute commands `nvidia-smi` and `nvcc --version` to ensure the host has drivers and toolchain installed.

Expected output:
```
root@ihmily:~#nvidia-smi                                                                         
+-----------------------------------------------------------------------------------------+                                                                             
| NVIDIA-SMI 580.95.05              Driver Version: 580.95.05      CUDA Version: 13.0     |                                                                             
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 4090        Off |   00000000:01:00.0 Off |                  Off |
| 30%   38C    P0             60W /  450W |       0MiB /  24564MiB |      2%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+

root@ihmily:~#nvcc --version

nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2021 NVIDIA Corporation
Built on Thu_Nov_18_09:45:30_PST_2021
Cuda compilation tools, release 11.5, V11.5.119
Build cuda_11.5.r11.5/compiler.30672275_0

```

The above results show that NVIDIA graphics drivers are correctly installed (580.95.05), and the CUDA runtime environment is visible (CUDA 13.0).

If the driver is working but Docker still reports this error, complete the [required NVIDIA Container Runtime setup](#required-nvidia-container-runtime-setup) near the beginning of this README.

## 📝 Custom Node Management

If you need to add or update custom nodes, you can use any of the following three methods:

1. Modify the `install_custom_nodes.sh` file, then rebuild the image.
2. Add directly through the mounted `custom_nodes` directory, then manually enter the container to install dependencies.
3. Install through ComfyUI-Manager in the ComfyUI interface.

## 🔗 Related Links

- [ComfyUI Official Repository](https://github.com/comfyanonymous/ComfyUI)
- [NVIDIA Driver Installation](https://www.nvidia.cn/drivers)
- [CUDA Toolkit Installation](https://developer.nvidia.com/cuda-toolkit-archive)
- [NVIDIA Docker Documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/)
