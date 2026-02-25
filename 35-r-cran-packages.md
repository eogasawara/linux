# Pacotes R via apt (lista grande).
#
# Este arquivo preserva a lista longa de pacotes r-cran-*.
#
# atualizar indices
```bash
yes | sudo apt update -qq
```
# install two helper packages we need
```bash
yes | sudo apt install --no-install-recommends software-properties-common dirmngr
```
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
```bash
yes | wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
```
# add the repo from CRAN for Ubuntu 24 (noble)
```bash
yes | sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
```
# install R itself
```bash
yes | sudo apt install --no-install-recommends r-base
```

#https://cran.r-project.org/bin/linux/ubuntu/fullREADME.html

#https://github.com/eddelbuettel/r2u

#step #1
```bash
yes | apt update -qq && apt install --yes --no-install-recommends wget \
    ca-certificates gnupg
yes | wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc \
    | tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc
```

#step #2 - noble #ubuntu 24
```bash
echo "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu noble main" \
     > /etc/apt/sources.list.d/cranapt.list
yes | apt update -qq
```

```bash
yes | apt-get update
yes | apt-get install r-base r-base-dev
yes | apt-get install libgsl-dev

yes | apt-get install libgdal-dev libproj-dev
yes | apt-get install wajig

yes | wajig update
yes | wajig distupgrade
yes | wajig install-suggested r-base 
yes | wajig install-suggested r-base-dev 
yes | wajig install-suggested r-recommended

yes | wajig install cargo 
yes | wajig install ffmpeg
yes | wajig install libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev
```

```bash
yes | wajig install r-cran-aer
yes | wajig install r-cran-amap
yes | wajig install r-cran-amelia
yes | wajig install r-cran-aplpack
yes | wajig install r-cran-av
yes | wajig install r-cran-base64enc
yes | wajig install r-cran-bibtex
yes | wajig install r-cran-car
yes | wajig install r-cran-caret
yes | wajig install r-cran-cba
yes | wajig install r-cran-class
yes | wajig install r-cran-classint
yes | wajig install r-cran-clisymbols
yes | wajig install r-cran-cluster
yes | wajig install r-cran-colorspace
yes | wajig install r-cran-commonmark
yes | wajig install r-cran-corrplot
yes | wajig install r-cran-covr
yes | wajig install r-cran-cowplot
yes | wajig install r-cran-cubature
yes | wajig install r-cran-curl
yes | wajig install r-cran-dbi
yes | wajig install r-cran-dbscan
yes | wajig install r-cran-desc
yes | wajig install r-cran-devtools
yes | wajig install r-cran-doparallel
yes | wajig install r-cran-dosnow
yes | wajig install r-cran-downlit
yes | wajig install r-cran-dplyr
yes | wajig install r-cran-dt
yes | wajig install r-cran-e1071
yes | wajig install r-cran-ellipse
yes | wajig install r-cran-factoextra
yes | wajig install r-cran-factominer
yes | wajig install r-cran-farver
yes | wajig install r-cran-fastmap
yes | wajig install r-cran-fbasics
yes | wajig install r-cran-fields
yes | wajig install r-cran-flashclust
yes | wajig install r-cran-flexmix
yes | wajig install r-cran-foreach
yes | wajig install r-cran-forecast
yes | wajig install r-cran-foreign
yes | wajig install r-cran-formatr
yes | wajig install r-cran-formattable
yes | wajig install r-cran-fpc
yes | wajig install r-cran-futile.logger
yes | wajig install r-cran-futile.options
yes | wajig install r-cran-gam
yes | wajig install r-cran-gbm
yes | wajig install r-cran-gbrd
yes | wajig install r-cran-gclus
yes | wajig install r-cran-geepack
yes | wajig install r-cran-geosphere
yes | wajig install r-cran-ggally
yes | wajig install r-cran-gganimate
yes | wajig install r-cran-ggdendro
yes | wajig install r-cran-ggplot2
yes | wajig install r-cran-ggpubr
yes | wajig install r-cran-ggraph
yes | wajig install r-cran-ggsci
yes | wajig install r-cran-ggsignif
yes | wajig install r-cran-ggthemes
yes | wajig install r-cran-gh
yes | wajig install r-cran-git2r
yes | wajig install r-cran-glmnet
yes | wajig install r-cran-gmm
yes | wajig install r-cran-gplots
yes | wajig install r-cran-gridextra
yes | wajig install r-cran-hexbin
yes | wajig install r-cran-hmisc
yes | wajig install r-cran-htmlwidgets
yes | wajig install r-cran-httr
yes | wajig install r-cran-igraph
yes | wajig install r-cran-ini
yes | wajig install r-cran-irkernel
yes | wajig install r-cran-isoband
yes | wajig install r-cran-jsonlite
yes | wajig install r-cran-kableextra
yes | wajig install r-cran-kernlab
yes | wajig install r-cran-knitr
yes | wajig install r-cran-laeken
yes | wajig install r-cran-lambda.r
yes | wajig install r-cran-lattice
yes | wajig install r-cran-latticeextra
yes | wajig install r-cran-lava
yes | wajig install r-cran-leaps
yes | wajig install r-cran-lifecycle
yes | wajig install r-cran-listenv
yes | wajig install r-cran-lmtest
yes | wajig install r-cran-locfit
yes | wajig install r-cran-lpsolve
yes | wajig install r-cran-lubridate
yes | wajig install r-cran-magrittr
yes | wajig install r-cran-mapproj
yes | wajig install r-cran-maptools
yes | wajig install r-cran-mass
yes | wajig install r-cran-matching
yes | wajig install r-cran-matchit
yes | wajig install r-cran-matrix
yes | wajig install r-cran-matrixmodels
yes | wajig install r-cran-maxlik
yes | wajig install r-cran-mclust
yes | wajig install r-cran-mcmc
yes | wajig install r-cran-mcmcpack
yes | wajig install r-cran-mfilter
yes | wajig install r-cran-mice
yes | wajig install r-cran-miniui
yes | wajig install r-cran-misctools
yes | wajig install r-cran-mitools
yes | wajig install r-cran-mlmetrics
yes | wajig install r-cran-mnormt
yes | wajig install r-cran-modelmetrics
yes | wajig install r-cran-msm
yes | wajig install r-cran-ncdf4
yes | wajig install r-cran-network
yes | wajig install r-cran-nnet
yes | wajig install r-cran-nortest
yes | wajig install r-cran-openssl
yes | wajig install r-cran-openxlsx
yes | wajig install r-cran-pander
yes | wajig install r-cran-party
yes | wajig install r-cran-patchwork
yes | wajig install r-cran-pbdzmq
yes | wajig install r-cran-pbkrtest
yes | wajig install r-cran-pbmcapply
yes | wajig install r-cran-pkgbuild
yes | wajig install r-cran-pkgload
yes | wajig install r-cran-plotly
yes | wajig install r-cran-plyr
yes | wajig install r-cran-polynom
yes | wajig install r-cran-processx
yes | wajig install r-cran-profilemodel
yes | wajig install r-cran-psych
yes | wajig install r-cran-quantreg
yes | wajig install r-cran-r.methodss3
yes | wajig install r-cran-r.oo
yes | wajig install r-cran-r.utils
yes | wajig install r-cran-r6
yes | wajig install r-cran-randomforest
yes | wajig install r-cran-ranger
yes | wajig install r-cran-rcmdcheck
yes | wajig install r-cran-rcolorbrewer
yes | wajig install r-cran-rcpparmadillo
yes | wajig install r-cran-rcppparallel
yes | wajig install r-cran-rcurl
yes | wajig install r-cran-rdpack
yes | wajig install r-cran-readr
yes | wajig install r-cran-readxl
yes | wajig install r-cran-rematch2
yes | wajig install r-cran-remotes
yes | wajig install r-cran-repr
yes | wajig install r-cran-reshape
yes | wajig install r-cran-reshape2
yes | wajig install r-cran-reticulate
yes | wajig install r-cran-rex
yes | wajig install r-cran-rio
yes | wajig install r-cran-rjava
yes | wajig install r-cran-rlang
yes | wajig install r-cran-rmysql
yes | wajig install r-cran-rocr
yes | wajig install r-cran-rodbc
yes | wajig install r-cran-roxygen2
yes | wajig install r-cran-rpart
yes | wajig install r-cran-rprojroot
yes | wajig install r-cran-rversions
yes | wajig install r-cran-scales
yes | wajig install r-cran-scatterplot3d
yes | wajig install r-cran-seriation
yes | wajig install r-cran-sessioninfo
yes | wajig install r-cran-sna
yes | wajig install r-cran-snow
yes | wajig install r-cran-snowballc
yes | wajig install r-cran-sourcetools
yes | wajig install r-cran-sparsem
yes | wajig install r-cran-sqldf
yes | wajig install r-cran-stringr
yes | wajig install r-cran-strucchange
yes | wajig install r-cran-survey
yes | wajig install r-cran-swagger
yes | wajig install r-cran-testthat
yes | wajig install r-cran-tibble
yes | wajig install r-cran-tidyr
yes | wajig install r-cran-tidyverse
yes | wajig install r-cran-tm
yes | wajig install r-cran-tmvtnorm
yes | wajig install r-cran-tseries
yes | wajig install r-cran-units
yes | wajig install r-cran-usethis
yes | wajig install r-cran-uuid
yes | wajig install r-cran-vcd
yes | wajig install r-cran-vgam
yes | wajig install r-cran-vim
yes | wajig install r-cran-warp
yes | wajig install r-cran-waveslim
yes | wajig install r-cran-webshot
yes | wajig install r-cran-wordcloud
yes | wajig install r-cran-writexl
yes | wajig install r-cran-xml
yes | wajig install r-cran-xopen
yes | wajig install r-cran-xtable
yes | wajig install r-cran-zeallot
yes | wajig install r-cran-zip
yes | wajig install r-cran-anomalize
yes | wajig install r-cran-arrow
yes | wajig install r-cran-arules
yes | wajig install r-cran-arulescba
yes | wajig install r-cran-arulessequences
yes | wajig install r-cran-arulesviz
yes | wajig install r-cran-atsa
yes | wajig install r-cran-audio
yes | wajig install r-cran-biclust
yes | wajig install r-cran-cdata
yes | wajig install r-cran-changepoint
yes | wajig install r-cran-circstats
yes | wajig install r-cran-clv
yes | wajig install r-cran-coefplot
yes | wajig install r-cran-descr
yes | wajig install r-cran-desctools
yes | wajig install r-cran-diagrammer
yes | wajig install r-cran-doby
yes | wajig install r-cran-dtw
yes | wajig install r-cran-dtwclust
yes | wajig install r-cran-elmnnrcpp
yes | wajig install r-cran-emd
yes | wajig install r-cran-eventdetectr
yes | wajig install r-cran-extrafont
yes | wajig install r-cran-extrafontdb
yes | wajig install r-cran-fma
yes | wajig install r-cran-fselector
yes | wajig install r-cran-ggmap
yes | wajig install r-cran-ggpmisc
yes | wajig install r-cran-gifski
yes | wajig install r-cran-hht
yes | wajig install r-cran-hmeasure
yes | wajig install r-cran-hrbrthemes
yes | wajig install r-cran-import
yes | wajig install r-cran-imputets
yes | wajig install r-cran-iswr
yes | wajig install r-cran-kendall
yes | wajig install r-cran-keras
yes | wajig install r-cran-kfas
yes | wajig install r-cran-lawstat
yes | wajig install r-cran-logistf
yes | wajig install r-cran-mcomp
yes | wajig install r-cran-miceadds
yes | wajig install r-cran-mlflow
yes | wajig install r-cran-moments
yes | wajig install r-cran-mumin
yes | wajig install r-cran-naivebayes
yes | wajig install r-cran-ncf
yes | wajig install r-cran-nnfor
yes | wajig install r-cran-oce
yes | wajig install r-cran-ocedata
yes | wajig install r-cran-opennlp
yes | wajig install r-cran-osfr
yes | wajig install r-cran-otsad
yes | wajig install r-cran-padr
yes | wajig install r-cran-peakram
yes | wajig install r-cran-pkgdown
yes | wajig install r-cran-pmml
yes | wajig install r-cran-rattle
yes | wajig install r-cran-rcpphungarian
yes | wajig install r-cran-rjdbc
yes | wajig install r-cran-rjsonio
yes | wajig install r-cran-rlibeemd
yes | wajig install r-cran-rootsolve
yes | wajig install r-cran-roxygen2
yes | wajig install r-cran-rpostgres
yes | wajig install r-cran-rqdatatable
yes | wajig install r-cran-rquery
yes | wajig install r-cran-rsnns
yes | wajig install r-cran-rttf2pt1
yes | wajig install r-cran-rugarch
yes | wajig install r-cran-rweka
yes | wajig install r-cran-rwekajars
yes | wajig install r-cran-sigmoid
yes | wajig install r-cran-smooth
yes | wajig install r-cran-smotefamily
yes | wajig install r-cran-sparklyr
yes | wajig install r-cran-splus2r
yes | wajig install r-cran-stinepack
yes | wajig install r-cran-sweep
yes | wajig install r-cran-tensorflow
yes | wajig install r-cran-tfdatasets
yes | wajig install r-cran-tibbletime
yes | wajig install r-cran-tidyquant
yes | wajig install r-cran-timetk
yes | wajig install r-cran-topicmodels
yes | wajig install r-cran-tree
yes | wajig install r-cran-tsmining
yes | wajig install r-cran-tsmp
yes | wajig install r-cran-tsoutliers
yes | wajig install r-cran-tspred
yes | wajig install r-cran-useful
yes | wajig install r-cran-vars
yes | wajig install r-cran-wavelets
yes | wajig install r-cran-wrapr
yes | wajig install r-cran-wvplots
yes | wajig install r-cran-xlconnect
yes | wajig install r-cran-xlsx
yes | wajig install r-cran-xlsxjars
yes | wajig install r-cran-countrycode
yes | wajig install r-cran-packagerank
yes | wajig install r-cran-dlstats
```

```bash
#yes | wajig install r-cran-daltoolbox
#yes | wajig install r-cran-daltoolboxdp
#yes | wajig install r-cran-harbinger
#yes | wajig install r-cran-tspredit
#yes | wajig install r-cran-stmotif
```


### novos pacotes
```bash
yes | wajig install r-cran-censobr
yes | wajig install r-cran-sidrar
yes | wajig install r-cran-fitdistrplus
yes | wajig install r-cran-adabag
```

# limpar as pastas de componentes instalados sem aviso
```bash
./clean-r.sh
```

#apt search r-cran- | grep -in "^r-cran-"
# Referencias:
# - https://cran.r-project.org/
