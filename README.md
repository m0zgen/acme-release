# Acme Release

Interactive script for run `acme.sh` for defined domain name. After certs will released script will try to install certs to 
`$TARGET` catalog

## Options

Acme path:
```shell
ACME=/$USER/.acme.sh/acme.sh
```

Target catalog:
```shell
TARGET=/etc/nginx/certs
```

## Example

Checking domain:
```shell
./run.sh
Enter Domain Name: example.com
Checking domain for exists...
Ok.
Release certs for: example.com? (y/n or enter for exit)
```

Catching bad domain:
```bash
Enter Domain Name: example.xom
Checking domain for exists...
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 45056
Domain does not exists. Exit. Bye.
```
