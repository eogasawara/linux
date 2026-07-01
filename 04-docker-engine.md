Docker Engine no Ubuntu 24.04 LTS.

Objetivo:
- Instalar Docker de forma previsivel
- Permitir uso por usuarios sem `sudo`
- Nao colocar usuarios no grupo `docker`

Politica deste servidor:
- So o administrador usa Docker com privilegio de host
- Usuarios comuns nao entram no grupo `docker`
- Usuarios comuns usam `Docker Rootless`

Por que isso importa:
- O grupo `docker` equivale, na pratica, a acesso de administrador da maquina
- Em servidor compartilhado, isso nao e aceitavel

## 1. Instalar Docker no host

Usar o repositorio oficial do Docker:
```bash
apt remove -y docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc
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

Instalar o minimo para:
- administrador usar Docker no host
- usuarios usarem `Docker Rootless`

```bash
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
apt install -y docker-ce-rootless-extras uidmap dbus-user-session
```

Validar:
```bash
docker --version
docker compose version
```

## 2. Decidir se o daemon rootful vai ficar ativo

Se voce, administrador, tambem vai usar Docker no host:
```bash
systemctl enable --now docker
sudo docker run hello-world
```

Se os usuarios vao usar apenas `Docker Rootless` e voce nao precisa do daemon rootful ligado o tempo todo:
- nao e obrigatorio habilitar `docker.service`

Observacao:
- `Docker Rootless` usa um daemon por usuario
- ele nao depende do socket global `/var/run/docker.sock`

## 3. Nao usar o grupo `docker`

Motivo:
- quem entra no grupo `docker` ganha acesso equivalente a `root`
- neste servidor, isso e proibido para usuarios comuns

## 4. Preparar um usuario para Docker Rootless

Cada usuario precisa ter faixas em `/etc/subuid` e `/etc/subgid`.

Checar:
```bash
grep '^foo:' /etc/subuid
grep '^foo:' /etc/subgid
```

Se nao existir, criar:
```bash
usermod --add-subuids 100000-165535 --add-subgids 100000-165535 foo
```

Permitir que o servico do usuario suba mesmo sem sessao aberta:
```bash
loginctl enable-linger foo
```

## 5. Instalacao que cada usuario executa na propria conta

O proprio usuario, sem `sudo`, roda:
```bash
dockerd-rootless-setuptool.sh install
systemctl --user enable --now docker
docker context use rootless
docker run hello-world
docker compose version
```

Se quiser conferir:
```bash
docker info
docker context ls
```

## 6. Como o usuario usa no dia a dia

Exemplos:
```bash
docker ps
docker compose up -d
docker compose logs -f
docker compose down
```

Exemplo minimo com `compose.yaml`:
```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
```

Subir:
```bash
docker compose up -d
```

## 7. Limitacoes importantes do Rootless

Antes de adotar, saiba:
- portas abaixo de `1024` normalmente exigem ajuste extra
- algumas opcoes de rede funcionam diferente do modo rootful
- o comportamento de firewall tambem pode diferir

Para laboratorio e servidor compartilhado, isso costuma ser aceitavel.

## Resumo pratico

Neste servidor, a regra e:
- so o administrador controla o Docker do host
- usuarios comuns nao usam `sudo`
- usuarios comuns nao entram no grupo `docker`
- usuarios comuns usam `Docker Rootless`

Referencias:
- https://docs.docker.com/engine/install/ubuntu/
- https://docs.docker.com/engine/install/linux-postinstall/
- https://docs.docker.com/engine/security/rootless/
