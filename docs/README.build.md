# ComponentDB : Glassfish (Payara) Application

The CDB is an application within the Glassfish. Technically, we need `a single war` file. The following makefile rules replace the most of part of the prerequisites of `make configure-web-portal` `make unconfigure-web-portal`, and part of `cdb_deploy_web_portal.sh`, where  we have to modify the CDB Web application. In addtion, it covers also the specific rule is `make dist`.

The original `make dist` has two parts: one is to do `make dist` in src/java for building a war file from the exist JAVA sources through `ant`. And the other is to `make dist` within src/python path, which seems like an empty rule.

And the original approach is to build some configuration are defined before a WAR file, and after extract the WAR file, and change some others, and compress it again to the WAR file. Here, we change everything before compressing the WAR file. Thus, the final WAR file remains intact. We can use it to deploy the application in the runnign domain of Payara server.

## ANT and JAVA

Unfornately, CDB needs the OpenJDK 11 instead of 8, so we have to use the different JAVA from Payara server configuration. Now, due to the lack of my knowledge, I am not sure it will be fine to use JAVA 11 to run Paraya 5.192. By naive googling, I was told it is OK. We will see what we get later.

The variable rule can be used to extract any ANT related variables within this building system such as

```bash
ComponentDB-env (master)$ make vars FILTER=ANT_

------------------------------------------------------------
>>>>          Current Envrionment Variables             <<<<
------------------------------------------------------------

ANT_ARGS = -Dant.home=/usr/share/ant  -Dlibs.CopyLibs.classpath=lib/org-netbeans-modules-java-j2seproject-copylibstask.jar
ANT_CDB = /usr/share/ant/bin/ant
ANT_HOME = /usr/share/ant
```

* JAVA and ANT versions can be checked via the following rule:

```bash
ComponentDB-env (master)$ make info.ant
>>> Ant
Apache Ant(TM) version 1.10.5 compiled on August 27 2018
>>> JAVA
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment (build 11.0.8+10-post-Debian-1deb10u1)
OpenJDK 64-Bit Server VM (build 11.0.8+10-post-Debian-1deb10u1, mixed mode, sharing)
>>>
```

* Default JAVA and ANT versions on Debian 10 are used.

## Master Build

The rule does two tasks (JAVA and Python) together and include all build rules shown in next paragraph.

```bash
make build
```

## Build Rules

```bash
make clean        : Clean
make build.java   : Build the cdb java application.
make clean.java   : Clean the cdb java application
make build.python : Build the Python plugin (?), still unclear
make info.ant     : Print ANT and JAVA versions
make dist.ant     : Build the cdb java application, create a war file.
compile.ant       : Compile the cdb java application.

conf.update_plugin              : Create CDB configuration
conf.build_propertiles_file     : Update $(CDB_BUILD_PROPERTIES_FILE)
conf.web.xml                    : Update $(CDB_GLASSFISH_WEB_XML_FILE)
conf.cdb_portal_properties_file : Update $(CDB_PORTAL_PROPERTIES_FILE)
conf.persistence.xml            : Update $(CDB_CONF_PERSISTENCE_XML_FILE)
conf.css.changecolor            : Update all css files $(CDB_WEB_RESOURCES_CSS_FILES)

revertconf.cdb           : Keep the exist BUILD_PROPERTIES_FILE
conf.update_plugin.view  : Show which files are crated by conf.cdb
clean.conf.update_plugin : Remove CDB configuration
```

, where all variables can be inpsected via `make PRINT.VARIABLE`. For example,

```bash
ComponentDB-env (master)$ make PRINT.CDB_PORTAL_PROPERTIES_FILE
CDB_PORTAL_PROPERTIES_FILE = ComponentDB-src/src/java/CdbWebPortal/src/java/cdb.portal.properties
CDB_PORTAL_PROPERTIES_FILE's origin is file
```

## Building Error

JAVA 8 returns the following compiling error:

```bash
 ComponentDB-env (master)$ sudo update-alternatives --config java
There are 3 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                                  Priority   Status
------------------------------------------------------------
  0            /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/java   10800262  auto mode
  1            /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/java   10800262  manual mode
  2            /usr/lib/jvm/java-11-openjdk-amd64/bin/java            1111      manual mode
* 3            /usr/lib/jvm/zulu-8-amd64/jre/bin/java                 1804800   manual mode
```

* `String` class doesn't have the `.strip()` function in JAVA 8.

```bash
library-inclusion-in-manifest:

-do-compile:
    [mkdir] Created dir: /home/jhlee/gitsrc/ComponentDB-env/ComponentDB-src/src/java/CdbWebPortal/build/empty
    [mkdir] Created dir: /home/jhlee/gitsrc/ComponentDB-env/ComponentDB-src/src/java/CdbWebPortal/build/generated-sources/ap-source-output
    [javac] Compiling 394 source files to /home/jhlee/gitsrc/ComponentDB-env/ComponentDB-src/src/java/CdbWebPortal/build/web/WEB-INF/classes
    [javac] /home/jhlee/gitsrc/ComponentDB-env/ComponentDB-src/src/java/CdbWebPortal/src/java/gov/anl/aps/cdb/portal/controllers/extensions/ImportHelperMachineDesign.java:606: error: cannot find symbol
    [javac]             String varName = nameValueArray[0].strip();
    [javac]                                               ^
    [javac]   symbol:   method strip()
    [javac]   location: class String
    [javac] /home/jhlee/gitsrc/ComponentDB-env/ComponentDB-src/src/java/CdbWebPortal/src/java/gov/anl/aps/cdb/portal/controllers/extensions/ImportHelperMachineDesign.java:607: error: cannot find symbol
    [javac]             String varValue = nameValueArray[1].strip();
    [javac]                                                ^
    [javac]   symbol:   method strip()
    [javac]   location: class String
    [javac] Note: Some input files use or override a deprecated API.
    [javac] Note: Recompile with -Xlint:deprecation for details.
    [javac] Note: Some input files use unchecked or unsafe operations.
    [javac] Note: Recompile with -Xlint:unchecked for details.
    [javac] 2 errors

BUILD FAILED
/home/jhlee/gitsrc/ComponentDB-env/ComponentDB-src/src/java/CdbWebPortal/nbproject/build-impl.xml:859: The following error occurred while executing this line:
/home/jhlee/gitsrc/ComponentDB-env/ComponentDB-src/src/java/CdbWebPortal/nbproject/build-impl.xml:296: Compile failed; see the compiler error output for details.
```

## Results

The `CdbWebPortal.war` file is generated within `src/java/CdbWebPortal/dist` compressed from `src/java/CdbWebPortal/build/web`. The war file has more contents in `META-INF/MAINFEST.MF` file. Except that, everything is identical.

* `src/java/CdbWebPortal/build/web`

```bash
Manifest-Version: 1.0
```

* a `war` file

```bash
Manifest-Version: 1.0
Ant-Version: Apache Ant 1.10.5
Created-By: 11+28 (Oracle Corporation)
```

## Deploy

The following two methods are evaluated.

* command line

```bash
asadmin deploy CdbWebPortal.war
```

* auto-deploy

Put `CdbWebPortal.war` into `domains/production/autodeploy`. I will test them later with <https://github.com/jeonghanlee/Payara-env> before we actaully setup / install Paraya service.
