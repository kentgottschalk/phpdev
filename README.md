# phpdev

Very simple and lightweight docker-compse setup for PHP development.

For now it's mostly geared towards Drupal development, but it can easily be
used for other stuff.

## Getting started

Put your code in web/code folder. It's recommended to use a separate setup
for each of your projects. It's possible to have multiple sites in one setup,
but you will possibly need to create your own database.

Put your PHP configuration files in files/php/conf. For example if using Drupal
you can use the included example config:

```
$ cp files/examples/drupal-recommended.ini files/php/conf/
```

Nginx configuration files goes in files/web/sites. The project includes an
example which can be used for both Drupal 7 and 8. Just remember to change the
server_name and root. For example:

```
server_name drupal.test;
root /var/www/code/drupal;
```

The following command will start the php, web and db service, which is the 
minimum requirement to get running:

```
$ docker-compose up -d web
```

If you go to http://localhost you should now be able to see the phpinfo page.

You need to add your server_name to the local hosts file/DNS manually to visit
your site.

Optionally you can also start the memcached and adminer service.

The adminer service is available at:

http://localhost:8080

Mailhog available at:

http://localhost:8025/

## Commands

Run Drush command:

```
$ docker-compose run --rm --w /app/code/yoursite.test drush cc all
```

Or to get a shell in the Drush container override the entrypoint:

```
$ docker-compose run --rm --entrypoint sh drush
```

Likewise to run node container:

```
$ docker-compose run --rm --entrypoint sh node
```

## Xdebug

Coming up...
