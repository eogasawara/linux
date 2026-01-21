Instalacao do R (Ubuntu 24.04 LTS).

Repositorio CRAN:
```bash
yes | sudo apt update -qq
yes | sudo apt install --no-install-recommends software-properties-common dirmngr
yes | wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
yes | sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
yes | sudo apt update -qq
yes | sudo apt install --no-install-recommends r-base
```

r2u (opcional, binarios mais rapidos):
```bash
yes | apt update -qq && apt install --yes --no-install-recommends wget ca-certificates gnupg
yes | wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc | tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc
echo "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu noble main" > /etc/apt/sources.list.d/cranapt.list
yes | apt update -qq
```

Deps extras:
```bash
yes | apt-get install libgsl-dev
yes | apt-get install libgdal-dev libproj-dev
```

RStudio Server: ver `37-rstudio-server-apache.md`.

Referencias:
- https://cran.r-project.org/bin/linux/ubuntu/fullREADME.html
- https://eddelbuettel.github.io/r2u/
