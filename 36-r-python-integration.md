Integracao R e Python (padrao do sistema com override por usuario).

Definir Python padrao do R (reticulate):
```bash
vi /etc/R/Rprofile.site
```

Adicionar:
```
Sys.setenv(RETICULATE_PYTHON = "/opt/venv/dal/bin/python3")
```

Opcional: definir no arquivo de ambiente:
```bash
vi /etc/R/Renviron.site
```

Adicionar:
```
RETICULATE_PYTHON = "/opt/venv/dal/bin/python3"
```

Override por usuario:
- O usuario pode sobrescrever em `~/.Renviron` ou `~/.Rprofile`.

Exemplo para o usuario foo:
```bash
vi /home/foo/.Renviron
```
```
RETICULATE_PYTHON = "/opt/venv/dal/bin/python3"
```

Verificar no RStudio:
```r
reticulate::py_config()
```

Referencia:
- https://rstudio.github.io/reticulate/
