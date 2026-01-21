Manutencao e atualizacoes do sistema.

Atualizacao semanal:
```bash
yes | apt update
yes | apt upgrade
```

Corrigir pacotes quebrados:
```bash
sudo dpkg --configure -a
apt --fix-broken install
```

Limpeza:
```bash
apt-get autoremove
apt-get autoremove --purge -y
```

Atualizacao de release:
```bash
do-release-upgrade
```

Firmware:
```bash
fwupdmgr get-upgrades
fwupdmgr update
```

Referencia:
- https://ubuntu.com/server/docs
