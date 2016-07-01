#!/bin/sh

# make sure, the user has done a cd into the bundle (otherwise relative paths do not work)
if [ ! -e bin/check-file ]; then { echo >&2 "Please cd into the bundle before running this script."; exit 1; }
fi

FILENAME_DEFAULT=self_signed_server
echo -n "Filenames for the generated .key/.csr/.crt files [$FILENAME_DEFAULT]: "
read answer
# @see https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
FILENAME=${answer:-$FILENAME_DEFAULT}

SSL_DIR_DEFAULT=etc/cert
echo -n "Target directory for the generated files [$SSL_DIR_DEFAULT]: "
read answer
SSL_DIR=${answer:-$SSL_DIR_DEFAULT}

echo "--------"
echo "Filenames: $FILENAME (.key/.csr/.crt)"
echo "Target directory: $SSL_DIR"
echo "--------"
echo -n "Ready to go? (Cancel with Ctrl+c)"
read answer

SSL_CONF=etc/cert/openssl.cnf
openssl genrsa -out $SSL_DIR/$FILENAME.key
openssl req -new -key $SSL_DIR/$FILENAME.key -out $SSL_DIR/$FILENAME.csr -config $SSL_CONF
openssl x509 -req -days 1024 -in $SSL_DIR/$FILENAME.csr -signkey $SSL_DIR/$FILENAME.key -out $SSL_DIR/$FILENAME.crt

#remove the passphrase
cp $SSL_DIR/$FILENAME.key $SSL_DIR/$FILENAME.key.org