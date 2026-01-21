Jupyter no venv (servidor de desenvolvimento).

Instalar (dentro do venv):
```bash
source /opt/venv/dal/bin/activate
pip install jupyter
pip install notebook
pip install jupyter-server
deactivate
```

Iniciar notebook:
```bash
source /opt/venv/dal/bin/activate
jupyter notebook --ip='server.instituicao.exemplo' --port 8888
deactivate
```

Tunel SSH (maquina de casa):
```bash
ssh -L 8888:127.0.0.1:8888 foo@server.instituicao.exemplo
```

Abra no navegador:
```
http://127.0.0.1:8888
```

Kernel do R (apos instalar R):
```r
install.packages("IRkernel")
IRkernel::installspec(user=FALSE)
```

Referencias:
- https://jupyter.org/
