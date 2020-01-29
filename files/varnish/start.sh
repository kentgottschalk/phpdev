#!/bin/sh

mkdir -p /var/lib/varnish/`hostname` && chown nobody /var/lib/varnish/`hostname`

exec varnishd -j unix,user=varnish -F -S 'none' -s malloc,${VARNISH_MEMORY} -a :80 -T :6082 -f ${VARNISH_CONFIG_FILE}

sleep 1
varnishlog
