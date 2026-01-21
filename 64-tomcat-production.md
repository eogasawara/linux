Tomcat atras do Apache HTTPS (producao).

Instalar Java e Tomcat:
```bash
yes | apt install default-jdk
yes | apt install tomcat10 tomcat10-docs
```

Confirmar Tomcat em 8080:
```bash
vi /etc/tomcat10/server.xml
```

Proxy reverso no Apache (`/etc/apache2/sites-available/000-default-le-ssl.conf`):
```apache
ProxyPass /tomcat/ http://localhost:8080/
ProxyHTMLURLMap http://localhost:8080 /tomcat/

<Location /tomcat/>
    ProxyPassReverse /
    ProxyHTMLEnable On
    ProxyHTMLURLMap  /      /tomcat/
    RequestHeader    unset  Accept-Encoding
</Location>
```

Reiniciar servicos:
```bash
service tomcat10 restart
service apache2 restart
```

Referencia:
- https://tomcat.apache.org/
