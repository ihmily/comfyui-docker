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
    "https://github.com/Fannovel16/comfyui_controlnet_aux.git"
    "https://github.com/chrisgoringe/cg-use-everywhere.git"
    "https://github.com/kijai/ComfyUI-Florence2.git"
    "https://github.com/jags111/efficiency-nodes-comfyui.git"
    "https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git"
    "https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch.git"
    "https://github.com/Acly/comfyui-inpaint-nodes.git"
    "https://github.com/ltdrdata/was-node-suite-comfyui.git"
    "https://github.com/alexopus/ComfyUI-Image-Saver.git"
    "https://github.com/AlekPet/ComfyUI_Custom_Nodes_AlekPet.git"
    "https://github.com/kijai/ComfyUI-SUPIR.git"
    "https://github.com/cubiq/ComfyUI_InstantID.git"
    "https://github.com/kijai/ComfyUI-IC-Light.git"
    "https://github.com/cubiq/ComfyUI_essentials.git"
    "https://github.com/jamesWalker55/comfyui-various.git"
    "https://github.com/shadowcz007/comfyui-mixlab-nodes.git"
    "https://github.com/giriss/comfy-image-saver.git"
    "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git"
    "https://github.com/TTPlanetPig/Comfyui_TTP_Toolset.git"
    "https://github.com/city96/ComfyUI-GGUF.git"
    "https://github.com/kijai/ComfyUI-Florence2.git"
    "https://github.com/chflame163/ComfyUI_LayerStyle_Advance.git"
    "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git"
    "https://github.com/cubiq/PuLID_ComfyUI.git"
    "https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git"
    "https://github.com/welltop-cn/ComfyUI-TeaCache.git"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git"
    "https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git"
    "https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git"
    "https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait.git"
    "https://github.com/TTPlanetPig/Comfyui_TTP_Toolset.git"
    "https://github.com/nunchaku-tech/ComfyUI-nunchaku.git"
    "https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git"
    "https://github.com/M1kep/ComfyLiterals.git"
    "https://github.com/Jasper1566/ComfyUI-StableSR.git"
    "https://github.com/kijai/ComfyUI-WanVideoWrapper.git"
    "https://github.com/kijai/ComfyUI-HunyuanVideoWrapper.git"
    "https://github.com/theUpsider/ComfyUI-Logic.git"
    "https://github.com/TemryL/ComfyUI-IDM-VTON.git"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack.git"
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

echo "🔧 Installing custom global dependencies..."

CUSTOM_DEPS=(
    "ninja"
    "llama-cpp-python"
    "nunchaku"
)

for dep in "${CUSTOM_DEPS[@]}"; do
    echo "📦 Installing custom dependency: $dep"
    if pip install --no-cache-dir "$dep"; then
        echo "✅ Successfully installed: $dep"
    else
        echo "❌ Failed to install: $dep"
    fi
done

UPGRADE_DEPS=(
    "accelerate"
)

for dep in "${UPGRADE_DEPS[@]}"; do
    echo "🔄 Upgrading: $dep"
    if pip install --no-cache-dir -U "$dep"; then
        echo "✅ Successfully upgraded: $dep"
    else
        echo "❌ Failed to upgrade: $dep"
    fi
done

# === Special handling for SAM2 ===
echo "🚀 Installing SAM2 with --no-build-isolation for speed..."
if pip install --no-cache-dir --no-build-isolation "git+https://github.com/facebookresearch/sam2"; then
    echo "✅ SAM2 installed successfully!"
else
    echo "❌ Failed to install SAM2"
fi

echo "🎉 All custom nodes installation completed!"
