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
python -m pip install --upgrade pip

python -m pip install jupyter
python -m pip install notebook
python -m pip install jupyter-server
python -m pip install jupyter-client
python -m pip install jupyterlab
python -m pip install jupyterhub
python -m pip install ipykernel
python -m pip install ipywidgets
python -m pip install jsonschema
```

Pacotes de analise de dados (servidor de desenvolvimento):
```bash
python -m pip install numpy
python -m pip install pandas
python -m pip install scipy
python -m pip install matplotlib
python -m pip install scikit-learn
python -m pip install scikit-rf
python -m pip install scikit-build-core
python -m pip install imbalanced-learn
python -m pip install arrow
python -m pip install testresources
python -m pip install pyarrow
```

Pacotes de aprendizado profundo (servidor de desenvolvimento):
```bash
python -m pip install torch
python -m pip install torchvision
python -m pip install torchaudio
python -m pip install db-dtypes
python -m pip install torch-geometric
python -m pip install pytorch_lightning
python -m pip install gluonts
python -m pip install tensorflow
python -m pip install h5py
python -m pip install toolz
python -m pip install pyreadr
```

Finalizar:
```bash
python -m pip check
python -m pip list --outdated
deactivate

sudo chown -R foo:$HOSTNAME /opt/venv/dal
sudo chmod -R o+rx /opt/venv/dal
```

Referencia:
- https://pytorch.org/get-started/locally/
