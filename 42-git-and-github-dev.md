Git e GitHub (servidor de desenvolvimento).

Instalar Git:
```bash
yes | apt-get install git
```

Configurar identidade (por usuario):
```bash
git config --global user.name "Seu Nome"
git config --global user.email "you@example.com"
```

Chave SSH para GitHub (ed25519):
```bash
ssh-keygen -t ed25519 -C "you@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Ver chave publica (adicionar no GitHub):
```bash
cat ~/.ssh/id_ed25519.pub
```


Comandos para rebase de repositorio:
```bash
git checkout --orphan latest_branch
git add -A
git commit -am "startup"
git branch -D main
git branch -m main
git push -f origin main
```

Referencia:
- https://docs.github.com/authentication/connecting-to-github-with-ssh
