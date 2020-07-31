# Debugging Payara and ComponentDB service

## `[Payara 5.192] [WARNING] [] [java.util.prefs]`


```bash
[2020-07-29T20:54:10.615-0700] [Payara 5.192] [WARNING] [] [java.util.prefs] [tid: _ThreadID=177 _ThreadName=Timer-1] [timeMillis: 1596081250615] [levelValue: 900] [[
  Could not lock User prefs.  Unix error code 2.]]

[2020-07-29T20:54:10.616-0700] [Payara 5.192] [WARNING] [] [java.util.prefs] [tid: _ThreadID=177 _ThreadName=Timer-1] [timeMillis: 1596081250616] [levelValue: 900] [[
  Couldn't flush user prefs: java.util.prefs.BackingStoreException: Couldn't get file lock.]]
```

<https://www.ibm.com/support/pages/starting-websphere-application-server-gives-warning-message-could-not-lock-user-prefs>