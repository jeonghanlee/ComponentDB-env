# Configuration Env

Configuration Environment for ComponentDB at <https://github.com/AdvancedPhotonSource/ComponentDB>

## Requirements

```bash
make init
```

* Package, patch, and environment

```bash
make install.pkgs
source docker/scripts/.sourceme
```

```bash
$ tree -L 1
.
├── [jhlee    4.0K]  ComponentDB-src
├── [jhlee    4.0K]  configure
├── [jhlee    4.0K]  data
├── [jhlee    4.0K]  docker
├── [jhlee    4.0K]  docs
├── [jhlee    4.0K]  etc
├── [jhlee     18K]  LICENSE
├── [jhlee     916]  Makefile
├── [jhlee     586]  README.md
├── [jhlee    4.0K]  site-template
└── [jhlee    4.0K]  support-'short_hostname`
```

## Build support needed for the application

```bash
make support
```

## load enviornment variables with new support built

```bash
source ComponentDB-src/setup.sh
```

## Create deployment configuration

```bash
etc/cdb.deploy.conf
etc/cdb.openssl.cnf
```

```bash
make config
```
