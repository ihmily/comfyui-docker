# ComfyUI Docker 构建

简体中文 / [English](./README.md)

一个预配置的 ComfyUI Docker 镜像，包含 CUDA 12.4 支持和多个流行的自定义节点。

## 📦 包含的自定义节点

本项目镜像预装了以下自定义节点：

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

以及更多...

## 🛠️ 构建镜像

### 本地构建

```bash
docker build -t comfyui-full:gpu-cu124 .
```

## 📥 从 Docker Hub 拉取镜像

您也可以直接从 Docker Hub 拉取预构建的镜像，无需本地构建：

```bash
docker pull ihmily/comfyui-full:gpu-cu124
```

拉取完成后，可以直接使用 `ihmily/comfyui-full:gpu-cu124` 作为镜像名称运行容器。


## 🚀 运行容器

注意，以下运行命令均使用的是从远程拉取的镜像，如需运行自己本地构建的镜像，需将 `ihmily/comfyui-full:gpu-cu124` 改为 `comfyui-full:gpu-cu124` 。

### 基础运行命令

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e CUDA_DEVICE=0 \
  ihmily/comfyui-full:gpu-cu124
```

### 运行配置示例（推荐）

##### 挂载相关目录

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e CUDA_DEVICE=0 \
  -v "$HOME/.cache/huggingface/hub:/root/.cache/huggingface/hub" \
  -v "$HOME/.cache/torch/hub:/root/.cache/torch/hub" \
  -v "$pwd/models:/app/ComfyUI/models" \
  -v "$pwd/user:/app/ComfyUI/user" \
  -v "$pwd/output:/app/ComfyUI/output" \
  -v "$pwd/input:/app/ComfyUI/input" \
  ihmily/comfyui-full:gpu-cu124
```

为了能更方便管理自定义节点，可以挂载custom_nodes目录。注意，如果挂载后本地custom_nodes为空，这会导致容器内无任何ComfyUI节点。

##### 挂载相关目录(完整)

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e CUDA_DEVICE=0 \
  -v "$HOME/.cache/huggingface/hub:/root/.cache/huggingface/hub" \
  -v "$HOME/.cache/torch/hub:/root/.cache/torch/hub" \
  -v "$pwd/models:/app/ComfyUI/models" \
  -v "$pwd/user:/app/ComfyUI/user" \
  -v "$pwd/output:/app/ComfyUI/output" \
  -v "$pwd/input:/app/ComfyUI/input" \
  -v "$pwd/custom_nodes:/app/ComfyUI/custom_nodes" \
  ihmily/comfyui-full:gpu-cu124
```

如果是中国国内用户，访问huggingface网络不佳的情况下，可以配置一个huggingface镜像环境变量，运行容器时新增以下参数

```bash
-e HF_ENDPOINT="https://hf-mirror.com"
```

以上运行配置都可以根据自己的实际需求进行修改。

### 添加ComfyUI启动参数（可选）

#### 方法1：直接覆盖启动命令

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e CUDA_DEVICE=0 \
  ihmily/comfyui-full:gpu-cu124 \
  python ComfyUI/main.py --listen 0.0.0.0 --port 8188 --disable-metadata --disable-smart-memory
```

#### 方法2：使用环境变量EXTRA_ARGS

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -e CUDA_DEVICE=0 \
  -e EXTRA_ARGS="--disable-metadata --disable-smart-memory" \
  ihmily/comfyui-full:gpu-cu124
```

#### 常用启动参数

- `--disable-metadata` - 禁用元数据
- `--disable-smart-memory` - 禁用智能内存管理
- `--cpu` - 强制使用CPU
- `--lowvram` - 低显存模式
- `--normalvram` - 正常显存模式
- `--highvram` - 高显存模式
- `--gpu-memory-fraction 0.8` - 设置GPU内存使用比例为80%
- `--force-fp16` - 强制使用FP16精度
- `--force-fp32` - 强制使用FP32精度

## 📁 目录挂载说明

| 容器路径 | 挂载路径 | 说明 |
|---------|-------------|------|
| `/app/ComfyUI/models` | `/path/to/models` | 模型文件目录 |
| `/app/ComfyUI/custom_nodes` | `/path/to/custom_nodes` | 自定义节点目录 |
| `/app/ComfyUI/output` | `/path/to/output` | 输出文件目录 |
| `/app/ComfyUI/input` | `/path/to/input` | 输入文件目录 |
| `/app/ComfyUI/user` | `/path/to/user` | 用户目录（存储工作流文件) |
| `/root/.cache/huggingface/hub` | `/$home/.cache/huggingface/hub` | huggingface缓存目录 |
| `/root/.cache/torch/hub` | `/$home/.cache/torch/hub` | torch缓存目录 |

## 🔧 环境变量

- `CUDA_DEVICE`: 指定使用的 CUDA 设备 ID（默认为 0）
- `HF_ENDPOINT`: Huggingface中国镜像服务

## 🌐 访问 ComfyUI

容器启动后，在浏览器中访问：

```
http://localhost:8188
```

## 📋 系统要求

- **Docker**: 20.10 或更高版本
- **NVIDIA Docker**: 支持 GPU 的 Docker 运行时
- **GPU**: 支持 CUDA 12.4 的 NVIDIA GPU
- **内存**: 建议至少 8GB RAM
- **存储**: 建议至少 20GB 可用空间

## 🐛 故障排除

### 1. GPU 不可用

如报错：docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]].

执行命令 `nvidia-smi`  和 `nvcc --version` 确保宿主机已经安装驱动和工具链

执行结果如下：
```
root@ihmily:~#nvidia-smi                                                                                                                                         
+-----------------------------------------------------------------------------------------+                                                                             
| NVIDIA-SMI 580.95.05              Driver Version: 580.95.05      CUDA Version: 13.0     |                                                                             
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
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

上面结果显示 NVIDIA 显卡驱动已正确安装（580.95.05），CUDA 运行时环境可见（CUDA 13.0）。

说明可能是container-toolkit未安装

```bash
# Ubuntu/Debian
# 安装 nvidia-container-toolkit
sudo apt-get install -y nvidia-container-toolkit

# 配置 Docker 使用 NVIDIA 作为运行时
sudo nvidia-ctk runtime configure --runtime=docker

# 重启 Docker 服务
sudo systemctl restart docker
```


## 📝 自定义节点管理

如果需要添加或更新自定义节点，可以实现下面三种方法中任意一种：

1. 修改 `install_custom_nodes.sh` 文件，然后重新构建镜像。
2. 通过挂载的 `custom_nodes` 目录直接添加，然后自己手动进入容器安装依赖。
3. 在ComfyUI界面使用ComfyUI-Manager中安装。

## 🔗 相关链接

- [ComfyUI 官方仓库](https://github.com/comfyanonymous/ComfyUI)
- [NVIDIA 驱动安装](https://www.nvidia.cn/drivers)
- [CUDA Toolkit(工具链)安装](https://developer.nvidia.com/cuda-toolkit-archive)
- [NVIDIA Docker 文档](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/)
