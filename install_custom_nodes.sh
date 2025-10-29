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
    "https://github.com/city96/ComfyUI-GGUF"
    "https://github.com/kijai/ComfyUI-Florence2"
    "https://github.com/chflame163/ComfyUI_LayerStyle_Advance"
    "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation"
    "https://github.com/cubiq/PuLID_ComfyUI"
    "https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet"
    "https://github.com/welltop-cn/ComfyUI-TeaCache"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/ssitu/ComfyUI_UltimateSDUpscale"
    "https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved"
    "https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait"
    "https://github.com/Lightricks/ComfyUI-LTXVideo"
    "https://github.com/TTPlanetPig/Comfyui_TTP_Toolset"
    "https://github.com/nunchaku-tech/ComfyUI-nunchaku"
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
# Search in both level 1 and level 2 directories
echo "🔍 Searching and installing requirements.txt files..."
while IFS= read -r req_file; do
    dir=$(dirname "$req_file")
    echo "📦 Installing dependencies: $dir"
    if pip install --no-cache-dir -r "$req_file"; then
        echo "✅ Installed: $dir"
    else
        echo "⚠️  Failed to install: $dir"
    fi
done < <(find . -maxdepth 3 -name "requirements.txt" -type f)

echo "🎉 All custom nodes installation completed!"
