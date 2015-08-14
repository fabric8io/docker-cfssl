FROM gliderlabs/alpine:3.2
MAINTAINER  Jimmi Dyson <jimmidyson@gmail.com>

RUN set -ex \
    && apk add --update -t build-deps make git go \
    && wget "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/8/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" \
    && wget "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/8/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" \
    && apk add --allow-untrusted glibc-2.21-r2.apk glibc-bin-2.21-r2.apk \
    && rm -f glibc-2.21-r2.apk glibc-bin-2.21-r2.apk \
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
    && mkdir /go \
    && export GOPATH=/go \
    && go get github.com/GeertJohan/go.rice/rice \
    && git clone https://github.com/cloudflare/cfssl.git /go/src/github.com/cloudflare/cfssl \
    && cd /go/src/github.com/cloudflare/cfssl/ \
    && git checkout 1.1.0 \
    && cd cli/serve \
    && /go/bin/rice embed-go \
    && cd ../../ \
    && go get -tags nopkcs11 github.com/cloudflare/cfssl/cmd/... \
    && mv /go/bin/* /bin/ \
    && git clone https://github.com/cloudflare/cfssl_trust.git /etc/cfssl \
    && mkbundle -f /etc/cfssl/int-bundle.crt /etc/cfssl/intermediate_ca/ \
    && mkbundle -f /etc/cfssl/ca-bundle.crt /etc/cfssl/trusted_roots/ \
    && apk del --purge build-deps make git go \
    && rm -rf /go /var/cache/apk/* \
    && apk-install bash openssl

ENV CFSSL_CA_HOST=example.localnet \
    CFSSL_CA_ALGO=ecdsa \
    CFSSL_CA_KEY_SIZE=384 \
    CFSSL_ADDRESS=127.0.0.1 \
    CFSSL_PORT=8888 \
    CFSSL_CA_ORGANIZATION="Internet Widgets, LLC" \
    CFSSL_CA_ORGANIZATIONAL_UNIT="Certificate Authority" \
    CFSSL_CA_POLICY_FILE=/etc/cfssl/ca_policy.json

WORKDIR /etc/cfssl

ENTRYPOINT [ "/start-cfssl" ]

COPY start-cfssl /start-cfssl
