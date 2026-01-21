Base do sistema (usuarios e grupos).

Criar grupo e associar usuario:
```bash
groupadd $HOSTNAME
usermod -a -G $HOSTNAME foo
```

Referencia:
- https://manpages.ubuntu.com/manpages/noble/en/man8/usermod.8.html
