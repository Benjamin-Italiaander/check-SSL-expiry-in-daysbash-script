## This is a more sciptable way of generation SSL info


The base of this second script is this line, it creates a variable calles ssl_cert you can collect all your data from this without reconnect to the different servers.

```bash
  ssl_cert=$(echo "GET / HTTP/1.0 EOT" | \
			openssl s_client -showcerts -servername $i -connect $i:443 2>/dev/null | \
			openssl x509 -inform pem -noout -text)
```


As a example you can search for the issuing date like this:

```bash
before=$(printf "$ssl_cert" | grep 'Not Before' | sed 's%Not Before: %%' |  sed -e 's/^[ \t]*//'  )
```bash

A small explanatin of the above
```bash
# Simply print the content of the ssl_cert variable
printf "$ssl_cert"
```
```bash
printf "$ssl_cert" | grep 'Not Before'
# Now combine printing and serching for a specific line, in this case the content "Not Before"
```


