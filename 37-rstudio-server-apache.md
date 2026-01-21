RStudio Server atras do Apache HTTPS.

Dependencias:
```bash
yes | apt-get install gdebi-core
```

Baixar e instalar (Ubuntu 24 LTS):
```bash
RSTUDIO_DEB_URL="https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.09.1-401-amd64.deb"
# Verifique no site da Posit se existe versao mais nova.
yes | wget "$RSTUDIO_DEB_URL" -O rstudio-server.deb
yes | gdebi rstudio-server.deb
```

Proxy reverso no Apache (`/etc/apache2/sites-available/000-default-le-ssl.conf`):
```apache
RedirectMatch permanent ^/rstudio$ /rstudio/

RewriteEngine on
RewriteCond %{HTTP:Upgrade} =websocket
RewriteRule /rstudio/(.*)     ws://localhost:8787/$1  [P,L]
RewriteCond %{HTTP:Upgrade} !=websocket
RewriteRule /rstudio/(.*)     http://localhost:8787/$1 [P,L]
ProxyPass /rstudio/ http://localhost:8787/
ProxyPassReverse /rstudio/ http://localhost:8787/

RewriteCond %{HTTP:Connection} Upgrade [NC]
RewriteCond %{HTTP:Upgrade} websocket [NC]
```

Reiniciar servicos:
```bash
service rstudio-server restart
service apache2 restart
```

Referencia:
- https://posit.co/download/rstudio-server/
