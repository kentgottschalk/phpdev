FROM thiagofigueiro/varnish-alpine-docker:3.6

# Replace the start up script to enable admin terminal and provide some
# additional options to the varnish deamon start up command. For extsensive
# list of available commands see:
# https://github.com/wodby/varnish/blob/965f87b74798ebab37742051cb324514c46aba4d/templates/varnishd.init.d.tmpl
# For now we also provide -S 'none' to disable varnishadm secret auth. Since
# this is only meant to be used for local dev the security is not necessary
# and the added complexity can be avoided.
RUN rm /start.sh
COPY files/varnish/start.sh /start.sh

# Expose the server AND the varnishadm terminal.
EXPOSE 80 6082
