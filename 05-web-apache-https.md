Apache HTTPS (ponto de entrada publico).

Convencao de document root:
- Institucional: `/var/www/html`
- Por usuario: `/home/<user>/public_html` (requer `userdir`)

Instalacao base:
```bash
yes | apt update
yes | apt upgrade
yes | apt install apache2
yes | apt install mysql-server
yes | apt install php libapache2-mod-php php-mysql
```

Ativar modulos do Apache:
```bash
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_byrequests
a2enmod proxy_html
a2enmod headers
a2enmod proxy_wstunnel
a2enmod proxy_fcgi
a2enmod ssl
a2enmod rewrite
a2enmod proxy_ajp
```

HTTPS com certbot:
```bash
yes | apt install certbot python3-certbot-apache
certbot
```

Userdir (sites por usuario):
```bash
apt install php libapache2-mod-php php-mysql
a2enmod php8.3
a2enmod userdir
```

Snippet para userdir:
```apache
<Directory /home/*/public_html>
Options +ExecCGI
AddHandler cgi-script .cgi .py
</Directory>
```

CGI em Python (opcional):
```bash
apt install python-is-python3
apt install libapache2-mod-python
a2enmod cgi
a2enmod mpm_prefork
service apache2 restart
```

Teste CGI:
```bash
vi /home/foo/public_html/first.py
```
```python
#!/usr/bin/python3
print("Content-type: text/html\n")
print("Ola, mundo!")
```
```bash
chmod +x /home/foo/public_html/first.py
```

Politica de acesso a banco:
- MySQL apenas local; acesso remoto somente via tunel SSH.

Tunel MySQL (cliente):
```bash
ssh -L 3306:127.0.0.1:3306 foo@server.instituicao.exemplo
```

Conexao MySQL (cliente):
```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
```

Referencias:
- https://httpd.apache.org/docs/2.4/
- https://certbot.eff.org/
