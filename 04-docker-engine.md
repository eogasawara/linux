Docker Engine no Ubuntu 24.04 LTS.

Quando usar:
- Para empacotar aplicacoes e servicos em containers
- Para executar stacks com `docker compose`

Remover pacotes conflitantes:
```bash
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
  apt remove -y $pkg
done
```

Preparar repositorio oficial do Docker:
```bash
apt update
apt install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
cat <<EOF > /etc/apt/sources.list.d/docker.sources
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
apt update
```

Instalar Docker Engine, Compose e Buildx:
```bash
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Habilitar no boot e validar:
```bash
systemctl enable --now docker
systemctl status docker --no-pager
docker run hello-world
docker compose version
```

Uso pelos usuarios:
- Por padrao, apenas `root` ou `sudo` podem usar `docker`
- Para permitir uso sem `sudo`, adicione o usuario ao grupo `docker`
- Membros do grupo `docker` recebem privilegios equivalentes a `root`; use apenas para usuarios confiaveis

Criar grupo e adicionar usuarios:
```bash
getent group docker >/dev/null || groupadd docker
usermod -aG docker foo
```

Aplicar a mudanca de grupo:
- O usuario deve encerrar a sessao SSH e entrar novamente
- Alternativa no shell atual:
```bash
newgrp docker
```

Teste como usuario comum:
```bash
docker ps
docker run --rm alpine:3.22 uname -a
```

Arquivos e comandos usuais:
- Socket do daemon: `/var/run/docker.sock`
- Unidade systemd: `docker.service`
- Dados locais: `/var/lib/docker`

Observacao de firewall:
- Se houver regras locais, prefira ajustes na cadeia `DOCKER-USER`

Referencias:
- https://docs.docker.com/engine/install/ubuntu/
- https://docs.docker.com/engine/install/linux-postinstall/
