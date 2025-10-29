#!/bin/bash

set -ex

# Custom nodes repository list
REPOS=(
    "https://github.com/ltdrdata/ComfyUI-Manager.git"
    "https://github.com/ihmily/ComfyUI-Light-Tool.git"
    "https://github.com/ihmily/comfy-deploy.git"
    "https://github.com/crystian/ComfyUI-Crystools.git"
    "https://github.com/rgthree/rgthree-comfy.git"
    "https://github.com/chflame163/ComfyUI_LayerStyle.git"
    "https://github.com/yolain/ComfyUI-Easy-Use.git"
    "https://github.com/kijai/ComfyUI-KJNodes.git"
    "https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus.git"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git"
    "https://github.com/evanspearman/ComfyMath.git"
    "https://github.com/nullquant/ComfyUI-BrushNet.git"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack.git"
    "https://github.com/Fannovel16/comfyui_controlnet_aux.git"
    "https://github.com/chrisgoringe/cg-use-everywhere.git"
    "https://github.com/kijai/ComfyUI-Florence2.git"
    "https://github.com/jags111/efficiency-nodes-comfyui.git"
    "https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git"
    "https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch"
    "https://github.com/Acly/comfyui-inpaint-nodes"
    "https://github.com/ltdrdata/was-node-suite-comfyui"
    "https://github.com/alexopus/ComfyUI-Image-Saver"
    "https://github.com/AlekPet/ComfyUI_Custom_Nodes_AlekPet"
    "https://github.com/kijai/ComfyUI-SUPIR"
    "https://github.com/cubiq/ComfyUI_InstantID"
    "https://github.com/kijai/ComfyUI-IC-Light"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/jamesWalker55/comfyui-various"
    "https://github.com/shadowcz007/comfyui-mixlab-nodes"
    "https://github.com/giriss/comfy-image-saver"
    "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes"
    "https://github.com/TTPlanetPig/Comfyui_TTP_Toolset"
)

cd /app/ComfyUI/custom_nodes || exit 1

for repo in "${REPOS[@]}"; do
    repo_name=$(basename "$repo" .git)
    if [ ! -d "$repo_name" ]; then
        echo "🔍 Cloning: $repo"
        git clone --depth 1 "$repo"
    else
        echo "✅ Already exists, skipping clone: $repo_name"
    fi
done

# Iterate through each directory, install requirements.txt (if exists)
for dir in */; do
    if [ -f "$dir/requirements.txt" ]; then
        echo "📦 Installing dependencies: $dir"
        pip install --no-cache-dir -r "$dir/requirements.txt" || \
            echo "⚠️  Warning: Installation of $dir failed, continuing to next"
    else
        echo "✅ $dir has no requirements.txt, skipping..."
    fi
done

echo "🎉 All custom nodes installation completed!"
