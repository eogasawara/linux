code-server multiusuario (estilo hub) atras do Apache HTTPS.

Objetivo:
- Comportamento analogo ao JupyterHub publicado em subpath.
- Um processo `code-server` por usuario Linux.
- Acesso em `https://<host>/code/<usuario>/`.

Limite importante:
- Diferente do JupyterHub, o code-server nao tem "hub" nativo com PAM + spawn central.
- Neste modelo, cada usuario autentica no proprio code-server (senha no `config.yaml` de cada usuario).

Dependencias:
```bash
# Base e seguranca
01-base-os-and-users.md
02-security-ssh-keys.md
03-packages-and-updates.md

# HTTPS e proxy reverso
05-web-apache-https.md

# Setup base do code-server
39-code-server.md
```

Instalar code-server:
```bash
yes | apt-get install curl
wget https://code-server.dev/install.sh
bash install.sh
code-server --version
```

Gerar config por usuario:
```bash
# Ajuste scripts/code-server-user-bootstrap.R e troque <PASSWORD>
Rscript scripts/code-server-user-bootstrap.R
```

Regra de porta por usuario:
```text
PORTA = UID_LINUX + 8000
```

Cada usuario deve ter `~/.config/code-server/config.yaml` com este padrao:
```yaml
bind-addr: 127.0.0.1:<UID+8000>
auth: password
password: <PASSWORD_DO_USUARIO>
cert: false
base-path: /code/<USUARIO>
```

Criar servico systemd template em `/etc/systemd/system/code-server@.service`:
```ini
[Unit]
Description=code-server (%i)
After=network.target

[Service]
Type=simple
User=%i
Group=%i
ExecStart=/usr/bin/code-server --config /home/%i/.config/code-server/config.yaml
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
```

Ativar servico para cada usuario:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now code-server@alice
sudo systemctl enable --now code-server@bob
sudo systemctl status code-server@alice --no-pager
sudo systemctl status code-server@bob --no-pager
```

Arquivo de mapeamento usuario -> porta em `/etc/apache2/code-server-users.map`:
```text
# Exemplo:
# alice UID=1001 -> porta 9001
# bob   UID=1002 -> porta 9002
alice 9001
bob 9002
```

Apache: habilitar modulos necessarios:
```bash
sudo a2enmod proxy proxy_http proxy_wstunnel rewrite headers ssl
sudo systemctl reload apache2
```

Adicionar no VirtualHost SSL (`/etc/apache2/sites-available/000-default-le-ssl.conf`):
```apache
# begin code-server hub
RewriteEngine On
RewriteMap csusers txt:/etc/apache2/code-server-users.map

# /code/<user> -> /code/<user>/
RewriteRule ^/code/([^/]+)$ /code/$1/ [R=301,L]

# websocket
RewriteCond %{REQUEST_URI} ^/code/([^/]+)/(.*)$ [NC]
RewriteCond ${csusers:%1|NOTFOUND} !NOTFOUND
RewriteCond %{HTTP:Upgrade} =websocket [NC]
RewriteRule ^/code/([^/]+)/(.*)$ ws://127.0.0.1:${csusers:$1}/$2 [P,L]

# http
RewriteCond %{REQUEST_URI} ^/code/([^/]+)/(.*)$ [NC]
RewriteCond ${csusers:%1|NOTFOUND} !NOTFOUND
RewriteCond %{HTTP:Upgrade} !=websocket [NC]
RewriteRule ^/code/([^/]+)/(.*)$ http://127.0.0.1:${csusers:$1}/$2 [P,L]

ProxyPreserveHost On
RequestHeader set X-Forwarded-Proto "https"
RequestHeader set X-Forwarded-Port "443"
ProxyTimeout 600
# end code-server hub
```

Validar e reiniciar Apache:
```bash
sudo apache2ctl configtest
sudo systemctl restart apache2
```

Testes:
```bash
# Local no servidor (deve responder 200/302)
curl -I http://127.0.0.1:9001/
curl -I http://127.0.0.1:9002/
```

Abrir no navegador:
```text
https://<host>/code/alice/
https://<host>/code/bob/
```

Operacao:
- Para adicionar usuario novo: obter UID, calcular `porta = UID + 8000`, criar `config.yaml`, subir `code-server@<usuario>`, incluir no `code-server-users.map`, reiniciar Apache.
- Se houver erro de assets/rotas, confira `base-path` no `config.yaml` do usuario.

Referencia:
- https://coder.com/docs/code-server/latest
