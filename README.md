Configuration Env
===

Configuration Environment for ComponentDB at https://github.com/AdvancedPhotonSource/ComponentDB


# Requirements

* 
```
make init
```
* Package, patch, and environment 
```
make install.pkgs
source docker/scripts/.sourceme
```
```
data
support-`hostname -s`
etc
```

# Build support needed for the application
	
```
make support
```
# load enviornment variables with new support built.

```
source ComponentDB-src/setup.sh 
```

# Create deployment configuration

```
etc/cdb.deploy.conf
etc/cdb.openssl.cnf
```

```
make config
```

