#!/bin/sh -l

set -e -o pipefail

outdir=$HOME/certs/localhost
filename=localhost

if [[ $INPUT_OUTPUT_DIRECTORY ]]; then
	outdir=$INPUT_OUTPUT_DIRECTORY
fi

echo "Output directory is $outdir"

if [ ! -e $outdir ]; then
	echo "Creating $outdir"
	mkdir -p $outdir
fi

if [[ $INPUT_FIENAME ]]; then
	filename=$INPUT_FILENAME
fi

cert_filename=$filename.crt
key_filename=$filename.key

echo "Output filenames are $cert_filename, $key_filename"

# https://letsencrypt.org/docs/certificates-for-localhost/#making-and-trusting-your-own-certificates

configfile=.cert-config

set -x

printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth" \
	> $configfile
openssl req -x509 -out $cert_filename -keyout $key_filename \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config $configfile

mv -v $filename.crt $filename.key $outdir

set +x

rm $configfile

echo "::set-output name=certfile::${outdir}/${cert_filename}"
echo "::set-output name=keyfile::${outdir}/${key_filename}"
