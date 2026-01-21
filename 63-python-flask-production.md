Python Flask (producao, opcional).

Criar venv dedicado:
```bash
mkdir -p /opt/venv/flask
python3 -m venv /opt/venv/flask
chown -R foo:$HOSTNAME /opt/venv/flask
chmod -R o+rx /opt/venv/flask
```

Instalar pacotes (como usuario foo):
```bash
source /opt/venv/flask/bin/activate
pip install --upgrade pip

pip install flask
pip install flask-bcrypt
pip install flask-sqlalchemy
pip install gunicorn
pip install bcrypt
pip install blinker
pip install click
pip install colorama
pip install itsdangerous
pip install jinja2
pip install markupsafe
pip install packaging
pip install greenlet
```

Finalizar:
```bash
pip check
deactivate
```

Referencia:
- https://flask.palletsprojects.com/
