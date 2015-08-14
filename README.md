= CloudFlare's PKI/TLS toolkit - Dockerized

This is a dockerized version of https://github.com/cloudflare/cfssl.

```
$ docker run -p 8888:8888 -e CXFSSL_ADDRESS=0.0.0.0 fabric8/cfssl
```

This will generate a key & certificate. To provide these, mount them at
`/etc/cfssl/ca.pem` & `/etc/cfssl/ca-key.pem` respectively.

Volume should be provided at `/etc/cfssl`.

The following environment variables can be used to configure CFSSL:

. `CFSSL_CA_HOST` - CA hostname. Default: `example.localnet`
. `CFSSL_CA_ALGO` - Algorithm used to generate CA key. Default: `ecdsa`
. `CFSSL_CA_KEY_SIZE` - CA key length. Default: `521`
. `CFSSL_ADDRESS` - Address to bind `cfssl` server. Default: `127.0.0.1`
. `CFSSL_PORT` - Port to listen on. Default: `8888`
. `CFSSL_CA_ORGANIZATION` - `O` part of CA certificate name. Default: `Internet Widgets, LLC`
. `CFSSL_CA_ORGANIZATIONAL_UNIT` - `OU` part og CA certificate name. Default: `Certificate Authority`
. `CFSSL_CA_POLICY_FILE` - CA policy file (generated or provided). Default: `/etc/cfssl/ca_policy.json`
