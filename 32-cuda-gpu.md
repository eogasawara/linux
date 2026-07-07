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

Decisao:
- Se `nvidia-smi` falhar, rode o bloco "Instalar driver NVIDIA" e depois reinicie.
- Se `nvidia-smi` funcionar e `nvcc` nao existir, pule o bloco "Instalar driver NVIDIA" e rode o bloco "Instalar toolkit CUDA".
- Se `nvidia-smi` funcionar e `nvcc` ja existir, pule para "Variaveis de ambiente".

Instalar driver NVIDIA:
```bash
ubuntu-drivers autoinstall
reboot
```

Validar driver apos reboot:
```bash
nvidia-smi
```

Adicionar repositorio do CUDA:
```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt update
```

Se houver tentativa anterior de instalacao, warning de repositorio duplicado, ou se o `apt update` nao enxergar o repositorio CUDA:
```bash
apt purge -y cuda-keyring
rm -f /etc/apt/sources.list.d/cuda-ubuntu*.list
rm -f /usr/share/keyrings/cuda-archive-keyring.gpg
rm -f cuda-keyring_1.1-1_all.deb*
apt update

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i ./cuda-keyring_1.1-1_all.deb
apt update
```

Instalar toolkit CUDA:
```bash
apt install -y cuda-toolkit-13-3
```

Padrao recomendado para Ubuntu LTS:
- Use `cuda-toolkit-13-3` quando quiser fixar a release do toolkit.
- Use `cuda-toolkit` somente se quiser acompanhar automaticamente a release mais nova publicada no repositorio.

Observacao:
- `cuda-toolkit` acompanha novas releases automaticamente.
- `cuda-toolkit-13-3` fixa a release 13.3.x.
- So considere migrar para `cuda-toolkit-14` quando o PyTorch estavel e o restante do stack suportarem oficialmente a nova serie.

Validar compilador CUDA:
```bash
/usr/local/cuda/bin/nvcc --version
```

Se o binario existir mas `nvcc` ainda nao estiver no shell, configure o ambiente:
```bash
cat >/etc/profile.d/cuda.sh <<'EOF'
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
EOF

source /etc/profile.d/cuda.sh
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

Instalar monitor de GPU:
```bash
apt install -y nvtop
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

Monitorar uso durante os testes:
```bash
htop
nvtop
```

Referencias:
- https://docs.nvidia.com/cuda/cuda-installation-guide-linux/
- https://ubuntu.com/server/docs/nvidia-drivers-installation
