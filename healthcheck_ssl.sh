source .env
echo "Is Alive:" $(curl "https://$DOMAIN/isup" -sS)
