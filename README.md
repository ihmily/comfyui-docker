# ComfyUI Docker Build

English / [简体中文](./README_ZH.md)

A pre-configured ComfyUI Docker image with CUDA 12.4 support and multiple popular custom nodes.

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
docker build -t comfyui-full:gpu-cu124 .
```

## 📥 Pull from Docker Hub

You can also pull the pre-built image directly from Docker Hub without local building:

```bash
docker pull ihmily/comfyui-full:gpu-cu124
```

After pulling, you can directly use `ihmily/comfyui-full:gpu-cu124` as the image name to run the container.

## 🚀 Running the Container

### Basic Run Command

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e CUDA_DEVICE=0 \
  comfyui-full:gpu-cu124
```

### Mount Models and Custom Nodes Directories

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e CUDA_DEVICE=0 \
  -v "/path/to/your/models:/app/ComfyUI/models" \
  -v "/path/to/your/custom_nodes:/app/ComfyUI/custom_nodes" \
  comfyui-full:gpu-cu124
```

### Complete Configuration Example

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e CUDA_DEVICE=0 \
  -v "/root/ComfyUI/models:/app/ComfyUI/models" \
  -v "/root/ComfyUI/custom_nodes:/app/ComfyUI/custom_nodes" \
  -v "/root/ComfyUI/output:/app/ComfyUI/output" \
  -v "/root/ComfyUI/input:/app/ComfyUI/input" \
  comfyui-full:gpu-cu124
```

### Adding Startup Parameters

#### Method 1: Direct Command Override (Recommended)

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e CUDA_DEVICE=0 \
  comfyui-full:gpu-cu124 \
  python ComfyUI/main.py --listen 0.0.0.0 --port 8188 --disable-metadata --disable-smart-memory
```

#### Method 2: Using Environment Variables

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e CUDA_DEVICE=0 \
  -e EXTRA_ARGS="--disable-metadata --disable-smart-memory" \
  comfyui-full:gpu-cu124
```

#### Common Startup Parameters

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

## 🔧 Environment Variables

- `CUDA_DEVICE`: Specify the CUDA device ID to use (default: 0)

## 🌐 Accessing ComfyUI

After starting the container, access ComfyUI in your browser at:

```
http://localhost:8188
```

## 📋 System Requirements

- **Docker**: Version 20.10 or higher
- **NVIDIA Docker**: Docker runtime with GPU support
- **GPU**: NVIDIA GPU supporting CUDA 12.4
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

This might indicate that container-toolkit is not installed.

```bash
# Ubuntu/Debian
# Install nvidia-container-toolkit
sudo apt-get install -y nvidia-container-toolkit

# Configure Docker to use NVIDIA as runtime
sudo nvidia-ctk runtime configure --runtime=docker

# Restart Docker service
sudo systemctl restart docker
```

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
