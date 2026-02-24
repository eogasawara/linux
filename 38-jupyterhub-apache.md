JupyterHub com JupyterLab no venv, publicado em subpath via Apache HTTPS.

Dependencias:
```bash
# Base e seguranca
01-base-os-and-users.md
02-security-ssh-keys.md
03-packages-and-updates.md

# HTTPS e proxy reverso
05-web-apache-https.md

# Venv Python
31-python-venv-pytorch.md
```

Instalar pre-requisito Node/npm e proxy do JupyterHub:
```bash
sudo apt install -y npm
npm -v
sudo npm install -g configurable-http-proxy
which configurable-http-proxy
```

Instalar JupyterHub e JupyterLab no venv existente:
```bash
sudo /opt/venv/dal/bin/pip install -U pip
sudo /opt/venv/dal/bin/pip install -U jupyterhub jupyterlab notebook

/opt/venv/dal/bin/jupyterhub --version
/opt/venv/dal/bin/jupyterhub-singleuser --version
```

Preparar diretorios e gerar configuracao:
```bash
sudo mkdir -p /var/lib/jupyterhub
sudo chown root:root /var/lib/jupyterhub
sudo chmod 700 /var/lib/jupyterhub

sudo mkdir -p /etc/jupyterhub
sudo /opt/venv/dal/bin/jupyterhub --generate-config -f /etc/jupyterhub/jupyterhub_config.py
```

Arquivo `/etc/jupyterhub/jupyterhub_config.py`:
```python
import os

c.JupyterHub.bind_url = "http://127.0.0.1:8000/jupyter"
c.Spawner.default_url = "/lab"
c.Spawner.cmd = ["/opt/venv/dal/bin/jupyterhub-singleuser"]
c.Spawner.environment = {
    "PATH": "/opt/venv/dal/bin:" + os.environ.get("PATH", "")
}

# usuarios locais do Linux (PAM)
c.JupyterHub.authenticator_class = "pam"
c.Authenticator.allow_all = True
c.Authenticator.any_allow_config = True

# estado persistente fora do HOME
c.JupyterHub.cookie_secret_file = "/var/lib/jupyterhub/jupyterhub_cookie_secret"
c.JupyterHub.db_url = "sqlite:////var/lib/jupyterhub/jupyterhub.sqlite"
```

Teste rapido da configuracao:
```bash
sudo /opt/venv/dal/bin/jupyterhub -f /etc/jupyterhub/jupyterhub_config.py --debug
```

Criar servico systemd em `/etc/systemd/system/jupyterhub.service`:
```ini
[Unit]
Description=JupyterHub
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/var/lib/jupyterhub
Environment="PATH=/opt/venv/dal/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ExecStart=/opt/venv/dal/bin/jupyterhub -f /etc/jupyterhub/jupyterhub_config.py
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
```

Ativar e subir servico:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now jupyterhub
sudo systemctl status jupyterhub --no-pager
```

Logs:
```bash
sudo journalctl -u jupyterhub -f
```

Apache: habilitar modulos necessarios:
```bash
sudo a2enmod proxy proxy_http proxy_wstunnel rewrite headers ssl
sudo systemctl reload apache2
```

Adicionar no VirtualHost SSL (`/etc/apache2/sites-available/000-default-le-ssl.conf`):
```apache
# begin jupyterhub
RedirectMatch permanent ^/jupyter$ /jupyter/

RewriteEngine on
RewriteCond %{HTTP:Upgrade} =websocket [NC]
RewriteRule /jupyter/(.*) ws://127.0.0.1:8000/jupyter/$1 [P,L]
RewriteCond %{HTTP:Upgrade} !=websocket [NC]
RewriteRule /jupyter/(.*) http://127.0.0.1:8000/jupyter/$1 [P,L]

ProxyPass /jupyter/ http://127.0.0.1:8000/jupyter/
ProxyPassReverse /jupyter/ http://127.0.0.1:8000/jupyter/
ProxyPreserveHost On
RequestHeader set X-Forwarded-Proto "https"
RequestHeader set X-Forwarded-Port "443"
ProxyTimeout 600
# end jupyterhub
```

Validar e reiniciar Apache:
```bash
sudo apache2ctl configtest
sudo systemctl restart apache2
```

Teste local (tunel SSH opcional):
```bash
ssh -N -L 9999:127.0.0.1:8000 -p <PORTA_SSH> <USUARIO>@<HOST>
```

Abrir no navegador:
```text
https://<host>/jupyter/
# ou, com tunel:
http://127.0.0.1:9999/jupyter/
```

Notas:
- O aviso "Running JupyterHub without SSL" e esperado quando o SSL termina no Apache.
- Se pular tela de login por cookie de sessao antigo, testar em janela anonima ou acessar `/hub/logout`.
