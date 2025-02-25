#!/bin/bash

# In this example i just use google.com
i="google.com"

# Just check if DNS record exists
hostcheck=$(/usr/bin/host $i | head -n1 |  sed -e 's/^[ \t]*//' )

if [[ "$hostcheck" = *"not found:"* ]]; then
  printf "$i NO DNS RECORD FOUND \n"    
else
    # If record exists Generate a variable named ssl_cert with the ssl-certificate contents
      ssl_cert=$(echo "GET / HTTP/1.0 EOT" | \
			openssl s_client -showcerts -servername $i -connect $i:443 2>/dev/null | \
			openssl x509 -inform pem -noout -text)i
fi
    # Some second check if this exists
		if [[ "$ssl_cert" = *"Certificate"* ]]; then

		expdt=$(printf "$ssl_cert" | grep 'Not After' | sed 's%Not After : %%' |  sed -e 's/^[ \t]*//' )
		after=$(printf "$ssl_cert" | grep 'Not After' | sed 's%Not After : %%' |  sed -e 's/^[ \t]*//'  )
		before=$(printf "$ssl_cert" | grep 'Not Before' | sed 's%Not Before: %%' |  sed -e 's/^[ \t]*//'  )
		dns=$(printf "$ssl_cert" | grep 'DNS:' | sed 's%DNS:%%' |  sed -e 's/^[ \t]*//' )
		expdt=$(date -d "$(printf "$expdt")" '+%s'); 


		date_today=$(date +%s)
		calculation=$(echo "(($expdt - $date_today)  / 86400)" | bc)


		issuer=$(printf "$ssl_cert" | grep 'Issuer:'  | rev | sed 's/[,].*//' | rev | sed 's%CN = %%' |  sed -e 's/^[ \t]*//')

			if [[ "$calculation" -lt 100 ]]; then
				printf "\n### $FILE - $i ###\n"
				printf "Certificate domains: $dns \n"
				printf "Days to expire     : $calculation  \n"
				printf "Issue date         : $before \n"
				printf "Expire date        : $after \n"
				printf "Issued at          : $issuer \n"
				printf "Host check	   : $hostcheck \n"
			fi
		else
		printf "\n### $FILE - $i ###\n ERROR"
		
fi
done

done

