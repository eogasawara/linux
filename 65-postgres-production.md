PostgreSQL (producao, acesso local).

Instalar:
```bash
yes | apt install postgresql postgresql-contrib
service postgresql start
```

Definir senha:
```bash
su -l postgres
psql
alter user postgres with password '<senha>';
```

Acesso apenas local:
- Manter `listen_addresses` em localhost e nao liberar `pg_hba.conf` para hosts remotos.

Tunel SSH (cliente):
```bash
ssh -L 5432:127.0.0.1:5432 foo@server.instituicao.exemplo
```

Conexao (cliente, apos tunel):
```bash
psql -h 127.0.0.1 -p 5432 -U postgres
```

Backup:
```bash
su - postgres -c "/usr/bin/pg_dump $db | gzip -c > $DIR/$db.gz"
```

Restore:
```bash
gunzip $db.gz
su - postgres -c "psql -d $db -f $DIR/$db"
```

Referencia:
- https://www.postgresql.org/docs/
