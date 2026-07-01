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

## 4. Preparacao administrativa por usuario

Este passo e executado por voce, como administrador, para cada conta que vai usar Docker Rootless.

Cada usuario precisa ter faixas em `/etc/subuid` e `/etc/subgid`.

Neste documento, use `<login-do-usuario>` como o login real de uma conta ja existente.
Exemplos:
- `joao`
- `maria`
- `aluno01`

Checar:
```bash
grep '^<login-do-usuario>:' /etc/subuid
grep '^<login-do-usuario>:' /etc/subgid
```

Se nao existir, criar:
```bash
usermod --add-subuids 100000-165535 --add-subgids 100000-165535 <login-do-usuario>
```

Permitir que o servico do usuario suba mesmo sem sessao aberta:
```bash
loginctl enable-linger <login-do-usuario>
```

Resumo deste passo:
- voce faz isso uma vez para cada conta que tera Docker Rootless
- o proprio usuario nao roda esses comandos administrativos
- se `dbus-user-session` ainda nao tiver sido instalado no host, volte ao passo 1

## 5. Configuracao que o proprio usuario executa na conta dele

Este passo e executado pelo proprio usuario, sem `sudo`, na sessao da propria conta.
Nao use `su`, `sudo -iu` ou equivalente para este passo.
Entre diretamente na conta do usuario, por exemplo:
```bash
ssh <login-do-usuario>@<maquina>
```

Nao use terminal do RStudio/Posit para este passo.
Motivo:
- esse terminal pode nao criar a sessao com `XDG_RUNTIME_DIR`
- sem `XDG_RUNTIME_DIR`, o `Docker Rootless` cai em modo manual e o `systemctl --user` pode nao funcionar

Antes de instalar, confira se a sessao do usuario tem `systemd --user` ativo:
```bash
echo $XDG_RUNTIME_DIR
systemctl --user status
```

O esperado e:
- `XDG_RUNTIME_DIR` apontando para `/run/user/<uid>`
- `systemctl --user` funcionando sem erro

Se isso nao acontecer:
- saia da sessao atual
- entre diretamente na conta do usuario por SSH ou console
- nao continue com instalacao manual em `~/.docker/run` como padrao

O proprio usuario, sem `sudo`, roda:
```bash
dockerd-rootless-setuptool.sh install
systemctl --user enable --now docker
docker context use rootless
docker run hello-world
docker compose version
```

Se o usuario tentou instalar antes sem `systemd --user` e aparecer erro com socket em `~/.docker/run/docker.sock`:
```bash
unset DOCKER_HOST
docker context use default
docker context rm rootless
dockerd-rootless-setuptool.sh install
systemctl --user enable --now docker
docker context use rootless
docker info
```

Depois disso, o socket correto deve ser algo como:
- `/run/user/<uid>/docker.sock`

Se quiser conferir:
```bash
docker info
docker context ls
```

Resumo deste passo:
- cada usuario roda esses comandos uma vez na propria conta
- isso cria e habilita o daemon rootless daquele usuario
- o socket esperado do rootless fica em `/run/user/<uid>/docker.sock`

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
