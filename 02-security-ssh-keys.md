SSH e chaves.

Gerar chave RSA:
```bash
ssh-keygen -t rsa -C "foo@instituicao.exemplo"
```

Copiar chave para o servidor:
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub foo@server.instituicao.exemplo
```

Exemplos de tunel SSH:
```bash
ssh -L 3128:proxy.instituicao.exemplo:3128 foo@proxy.instituicao.exemplo
ssh -L 8081:127.0.0.1:8081 foo@server.instituicao.exemplo
```

Referencias:
- https://manpages.ubuntu.com/manpages/noble/en/man1/ssh.1.html
- https://manpages.ubuntu.com/manpages/noble/en/man1/ssh-keygen.1.html
