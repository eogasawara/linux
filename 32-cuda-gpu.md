CUDA + GPU (Ubuntu 24.04 LTS, instalacao do zero).

Checagem de hardware:
```bash
lshw -numeric -C display
lspci | grep -i nvidia
```

Headers e compilador:
```bash
yes | apt-get install linux-headers-$(uname -r)
gcc --version
```

Repositorios do CUDA (Ubuntu 24):
```bash
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/3bf863cc.pub | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/cuda-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/ /" | \
sudo tee /etc/apt/sources.list.d/cuda-ubuntu2404.list

sudo apt update
sudo apt upgrade
```

Driver recomendado pelo Ubuntu + toolkit:
```bash
ubuntu-drivers devices
ubuntu-drivers autoinstall
yes | apt install cuda-toolkit
```

Reinicie para carregar o driver:
```bash
reboot
```

Validar driver:
```bash
nvidia-smi
```

Validar compilador CUDA:
```bash
nvcc --version
```

Variaveis de ambiente:
```bash
vi /etc/profile.d/cuda.sh
```
```
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-12.4/lib64:$LD_LIBRARY_PATH"
```

Recarregar e checar:
```bash
source /etc/profile.d/cuda.sh
nvcc --version
```

Teste do PyTorch com GPU (no venv):
```bash
source /opt/venv/dal/bin/activate
python - <<'PY'
import torch
print("torch:", torch.__version__)
print("cuda available:", torch.cuda.is_available())
print("cuda version:", torch.version.cuda)
if torch.cuda.is_available():
    print("device:", torch.cuda.get_device_name(0))
PY
deactivate
```

Referencias:
- https://docs.nvidia.com/cuda/cuda-installation-guide-linux/
- https://ubuntu.com/server/docs/nvidia-drivers-installation
