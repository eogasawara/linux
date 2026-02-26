code-server (modo simples via tunel SSH).

Para modo multiusuario publicado no Apache HTTPS (estilo "hub"), veja:
- `40-code-server-hub-apache.md`

Instalar:
```bash
yes | apt-get install curl
wget https://code-server.dev/install.sh
bash install.sh
```

Configurar por usuario:
```bash
mkdir -p ~/.config/code-server
vi ~/.config/code-server/config.yaml
```

Exemplo:
```yaml
bind-addr: 127.0.0.1:8081
auth: password
password: <PASSWORD>
cert: false
```

Tunel SSH (cliente):
```bash
ssh -L 8081:127.0.0.1:8081 foo@server.instituicao.exemplo
```

Iniciar:
```bash
code-server
```

Opcional (systemd user):
```bash
systemctl --user enable --now code-server
systemctl --user status code-server --no-pager
```

Automacao:
- Use `scripts/code-server-user-bootstrap.R` para gerar config por usuario.

Referencia:
- https://coder.com/docs/code-server/latest
