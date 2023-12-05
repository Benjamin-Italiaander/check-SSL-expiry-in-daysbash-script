#!/bin/bash
TARGET=$1; 
expirationdate=$(date -d "$(: | openssl s_client -connect $TARGET:443 -servername $TARGET 2>/dev/null \
                              | openssl x509 -text \
                              | grep 'Not After' \
                              |awk '{print $4,$5,$7}')" '+%s'); 

date_today=$(date +%s)

calculation=$(echo "(($expirationdate - $date_today)  / 86400)" | bc)
echo "$calculation"
