Venv de Python com pacotes comuns e de desenvolvimento.

Criar venv (como root):
```bash
groupadd $HOSTNAME
usermod -a -G $HOSTNAME foo
mkdir -p /opt/venv/dal
python3 -m venv /opt/venv/dal
chown -R foo:$HOSTNAME /opt/venv/dal
chmod -R o+rx /opt/venv/dal
```

Pacotes comuns (como usuario foo):
```bash
source /opt/venv/dal/bin/activate
pip install --upgrade pip

pip install jupyter
pip install notebook
pip install jupyter-server
pip install jupyter-client
pip install ipykernel
pip install jsonschema
```

Pacotes de analise de dados (servidor de desenvolvimento):
```bash
pip install numpy
pip install pandas
pip install scipy
pip install matplotlib
pip install scikit-learn
pip install scikit-rf
pip install scikit-build-core
pip install imbalanced-learn
pip install arrow
pip install testresources
```

Pacotes de aprendizado profundo (servidor de desenvolvimento):
```bash
pip install torch
pip install torchvision
pip install torchaudio
pip install train
pip install db-dtypes
pip install early-stopping
pip install torch-geometric
pip install pytorch_lightning
pip install gluonts
pip install pyreadr
```

Finalizar:
```bash
pip check
pip list --outdated
deactivate

sudo chown -R foo:$HOSTNAME /opt/venv/dal
sudo chmod -R o+rx /opt/venv/dal
```

Referencia:
- https://pytorch.org/get-started/locally/
