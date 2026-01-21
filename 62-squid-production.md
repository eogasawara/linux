Squid (producao).

Instalar:
```bash
yes | apt-get install squid
```

Arquivo principal: `/etc/squid/squid.conf`
```conf
acl localnet src 0.0.0.1-0.255.255.255
acl localnet src fc00::/7
acl localnet src fe80::/10

acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777

http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost

auth_param digest program /usr/lib/squid/digest_file_auth -c /etc/squid/passwords
auth_param digest realm proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated

include /etc/squid/conf.d/*.conf
http_access deny all

http_port 3128
```

Reiniciar:
```bash
service squid restart
```

Tunel SSH (cliente):
```bash
ssh -L 3128:proxy.instituicao.exemplo:3128 foo@proxy.instituicao.exemplo
```

Desabilitar se nao for usar:
```bash
systemctl disable squid
```

No-proxy (exemplo):
```
127.0.0.1,localhost,instituicao.exemplo,overleaf.com,globo.com,google.com,sci-hub,facebook.com,linkedin.com,grammarly.com,bb.com.br,libgen,chat.openai.com,speedtest.net,latamt.ieeer9.org
```

Referencia:
- https://wiki.squid-cache.org/
