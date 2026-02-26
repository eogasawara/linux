code-server multiusuario (estilo hub) atras do Apache HTTPS em porta dedicada.

Objetivo:
- Comportamento analogo ao JupyterHub no login central (PAM).
- Um processo `code-server` por usuario Linux.
- Entrada publica unica: `https://<host>:8080/`.

Limite importante:
- O code-server nao tem "hub" nativo com PAM + spawn central.
- Neste modelo, a autenticacao PAM ocorre no Apache (usuario Linux).
- Com code-server `4.109.2`, nao usar `base-path` no `config.yaml`.

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

Regra de porta por usuario:
```text
PORTA_INTERNA = UID_LINUX + 8000
```

Cada usuario deve ter `~/.config/code-server/config.yaml` com este padrao:
```yaml
bind-addr: 127.0.0.1:<UID+8000>
auth: none
cert: false
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

Recarregar systemd:
```bash
sudo systemctl daemon-reload
```

Gerar config por usuario e subir servicos:
```bash
sudo Rscript scripts/code-server-user-bootstrap.R
```

Ao executar o script acima (ou `code-server.R`), ele:
- gera `~/.config/code-server/config.yaml` por usuario
- habilita e sobe `code-server@<usuario>` para cada usuario processado
- gera `/etc/apache2/code-server-users.map`

Checagem rapida dos servicos:
```bash
sudo systemctl status code-server@gpca --no-pager
sudo systemctl status code-server@eogasawara --no-pager
```

Arquivo de mapeamento usuario -> porta em `/etc/apache2/code-server-users.map`:
- Gerado automaticamente por `code-server.R` ou `scripts/code-server-user-bootstrap.R`.
- Formato esperado:
```text
# Exemplo:
# gpca UID=1000 -> porta 9000
# eogasawara UID=1002 -> porta 9002
gpca 9000
eogasawara 9002
```

Apache: habilitar modulos necessarios:
```bash
sudo apt install -y libapache2-mod-authnz-pam
sudo a2enmod proxy proxy_http proxy_wstunnel rewrite headers ssl
sudo a2enmod authnz_pam auth_basic
```

Apache: habilitar porta 8080 com TLS (`/etc/apache2/ports.conf`):
```apache
Listen 8080
```

Servico PAM do Apache (`/etc/pam.d/apache2`):
```text
auth    required  pam_unix.so
account required  pam_unix.so
```

Adicionar VirtualHost em `:8080` (`/etc/apache2/sites-available/code-server-hub-8080.conf`):
```apache
<IfModule mod_ssl.c>
<VirtualHost *:8080>
    ServerName albali.eic.cefet-rj.br

    RewriteEngine On
    RewriteMap csusers txt:/etc/apache2/code-server-users.map

    # Login Linux via PAM
    <Location />
        AuthType Basic
        AuthName "code-server"
        AuthBasicProvider PAM
        AuthPAMService apache2
        Require valid-user
    </Location>

    # Bloqueia usuario sem entrada no mapa
    RewriteCond %{LA-U:REMOTE_USER} (.+)
    RewriteCond ${csusers:%1|NOTFOUND} =NOTFOUND
    RewriteRule ^ - [F,L]

    # websocket
    RewriteCond %{LA-U:REMOTE_USER} (.+)
    RewriteCond %{HTTP:Upgrade} =websocket [NC]
    RewriteRule ^/(.*)$ ws://127.0.0.1:${csusers:%1}/$1 [P,L]

    # http
    RewriteCond %{LA-U:REMOTE_USER} (.+)
    RewriteCond %{HTTP:Upgrade} !=websocket [NC]
    RewriteRule ^/(.*)$ http://127.0.0.1:${csusers:%1}/$1 [P,L]

    ProxyPreserveHost On
    RequestHeader set X-Forwarded-Proto "https"
    RequestHeader set X-Forwarded-Port "8080"
    ProxyTimeout 600

    SSLCertificateFile /etc/letsencrypt/live/albali.eic.cefet-rj.br/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/albali.eic.cefet-rj.br/privkey.pem
    Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
</IfModule>
```

Ativar site e reiniciar Apache:
```bash
sudo a2ensite code-server-hub-8080.conf
sudo apache2ctl configtest
sudo systemctl restart apache2
```

Testes:
```bash
# Local no servidor (deve responder 200/302)
curl -I http://127.0.0.1:9000/
curl -I http://127.0.0.1:9002/
```

Abrir no navegador:
```text
https://albali.eic.cefet-rj.br:8080/
```

Operacao:
- Para adicionar usuario novo: criar usuario Linux, rodar o script novamente, reiniciar Apache.
- O roteamento interno continua por `UID + 8000`.
- Se um usuario autenticar e nao existir no `code-server-users.map`, Apache responde 403.

Referencia:
- https://coder.com/docs/code-server/latest
