#!/bin/sh

mkdir -p /var/lib/varnish/`hostname` && chown nobody /var/lib/varnish/`hostname`

if [ -n "${VARNISH_CONFIG_FILE}" ]; then
  exec varnishd -j unix,user=varnish -F -S 'none' -s malloc,${VARNISH_MEMORY} -a :80 -T :6082 -f "/etc/varnish/${VARNISH_CONFIG_FILE}"
else
  exec varnishd -j unix,user=varnish -F -S 'none' -s malloc,${VARNISH_MEMORY} -a :80 -T :6082 -b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}
fi

sleep 1
varnishlog
