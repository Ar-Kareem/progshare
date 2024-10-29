source .env
echo "Is Alive:" $(curl "https://$DOMAIN/isup" -k -s)