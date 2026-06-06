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

Instalar Docker Engine, Compose, Buildx e suporte a Rootless:
```bash
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras uidmap dbus-user-session
```

Habilitar no boot e validar:
```bash
systemctl enable --now docker
systemctl status docker --no-pager
docker run hello-world
docker compose version
```

Uso pelos usuarios em servidor compartilhado:
- Por padrao, apenas `root` ou `sudo` podem usar `docker`
- Em laboratorio, prefira `Docker Rootless` para usuarios comuns
- Nao adicione alunos ao grupo `docker`
- Membros do grupo `docker` recebem privilegios equivalentes a `root`

Recomendacao de seguranca:
- Use o grupo `docker` apenas para administradores confiaveis
- Para alunos e usuarios comuns, configure um daemon Rootless por usuario

Pre-requisitos administrativos por usuario:
- O usuario precisa ter faixas proprias em `/etc/subuid` e `/etc/subgid`
- Em contas criadas com `adduser`, isso normalmente ja existe
- Valide com:
```bash
grep '^foo:' /etc/subuid
grep '^foo:' /etc/subgid
```

Configurar Docker Rootless como usuario comum:
```bash
dockerd-rootless-setuptool.sh install
systemctl --user enable --now docker
docker context ls
docker info
```

Para iniciar automaticamente apos reboot, habilite linger uma vez como administrador:
```bash
loginctl enable-linger foo
```

Teste como usuario comum:
```bash
docker run hello-world
docker compose version
docker run --rm alpine:3.22 uname -a
```

Arquivos e comandos usuais:
- Rootful socket: `/var/run/docker.sock`
- Rootless socket: `/run/user/<uid>/docker.sock`
- Unidade rootful: `docker.service`
- Unidade rootless: `~/.config/systemd/user/docker.service`
- Dados rootful: `/var/lib/docker`
- Dados rootless: `~/.local/share/docker`

Observacao de firewall:
- Se houver regras locais, prefira ajustes na cadeia `DOCKER-USER`

Limitacoes do modo Rootless:
- Algumas opcoes avancadas de rede e portas privilegiadas exigem ajustes adicionais
- O comportamento de firewall e redes bridge difere do daemon rootful
- Se o objetivo for administracao completa do host ou simulacao fiel de producao, use VM dedicada

Referencias:
- https://docs.docker.com/engine/install/ubuntu/
- https://docs.docker.com/engine/install/linux-postinstall/
- https://docs.docker.com/engine/security/rootless/
