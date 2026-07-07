CUDA + GPU (Ubuntu 24.04 LTS).

Objetivo: validar primeiro o estado atual da maquina e instalar apenas o que estiver faltando.

Checagem de hardware:
```bash
lshw -numeric -C display
lspci | grep -i nvidia
```

Headers e compilador:
```bash
apt-get install -y linux-headers-$(uname -r)
gcc --version
```

Validar estado atual antes de instalar qualquer coisa:
```bash
nvidia-smi
nvcc --version
ubuntu-drivers devices
```

Interpretacao:
- Se `nvidia-smi` funcionar e `nvcc` nao existir, instale apenas o CUDA toolkit.
- Se `nvidia-smi` falhar, corrija/instale o driver NVIDIA antes de seguir.
- Se `nvcc` ja existir, valide o ambiente e teste o PyTorch.

Cenario desta maquina:
- Se `nvidia-smi` funcionar e `nvcc` nao existir, nao rode `ubuntu-drivers autoinstall`.
- Nesse caso, mantenha o driver atual e instale apenas o toolkit CUDA.

Instalar driver NVIDIA somente se necessario:
```bash
ubuntu-drivers autoinstall
reboot
```

Validar driver apos reboot:
```bash
nvidia-smi
```

Adicionar repositorio do CUDA somente se o toolkit estiver faltando:
```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt update
```

Instalar toolkit CUDA:
```bash
apt install -y cuda-toolkit-13
```

Opcao mais estavel para maquinas que executam `apt update` e `apt upgrade` com frequencia:
```bash
apt install -y cuda-toolkit-13-3
```

Observacao:
- `cuda-toolkit` acompanha novas releases automaticamente.
- `cuda-toolkit-13` limita upgrades a serie 13.x.
- `cuda-toolkit-13-3` fixa a release 13.3.x.

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
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
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
