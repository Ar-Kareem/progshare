source .env
echo "------------"
echo "Domain: $DOMAIN"
echo "------------"
echo "using dig"
dig $DOMAIN +nostats +nocomments +nocmd
echo "------------"
DNS_IP=$(dig +short $DOMAIN | tail -n1)
echo "DNS IP: $DNS_IP"
MY_IP=$(curl -s https://api.ipify.org/?format=text)
echo "My IP: $MY_IP"
IS_SAME=$(echo $DNS_IP | grep -c $MY_IP)
if [ $IS_SAME -eq 1 ]; then
  echo "DNS IP and My IP are the same"
else
  echo "DNS IP and My IP ARE NOT the same!!!"
  echo "MUST UPDATE DNS RECORDS"
fi
