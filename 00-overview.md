Objetivo:
- Servidor Ubuntu 24.04 LTS para ciencia de dados e producao
- Apache HTTPS como ponto de entrada publico
- RStudio Server atras do Apache (HTTPS + websocket)
- Tomcat atras do Apache (producao)
- code-server via tunel SSH
- Python + PyTorch com GPU

Ordem:
- Comum: 00 a 29
- Desenvolvimento: 30+
- Producao: 60+

Portas usadas:
- Apache HTTPS: 443
- RStudio Server: 8787 (localhost)
- code-server: 8081 (localhost)
- Jupyter: 8888 (opcional)
Producao:
- Tomcat: 8080 (localhost)
- Squid: 3128
