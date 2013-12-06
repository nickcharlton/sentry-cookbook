# sentry cookbook

A simple cookbook for installing the error logging and aggregation tool, [Sentry][].
It uses [runit][] for process monitoring, [nginx][] for the web server and 
[postgres][] for the data store.

## Requirements

* python
* nginx
* postgres
* runit

Tested on:

* Ubuntu Precise (12.04)

## Usage

It tries to use as little configuration options as possible and so you should be able
to get away with getting the domain to listen on, database details, email server
and the [secret key for Django][django_key]. An example role based on the included
`Vagrantfile`:

```ruby
name 'sentry'
description 'Configures a Sentry instance.'

run_list [
  'recipe[runit]',
  'recipe[python]',
  'recipe[nginx]',
  'recipe[postgres::server]',
  'recipe[sentry]'
]

default_attributes(
  'sentry' => {
    'nginx' => {'domain' => 'sentry.example.com'},
    'database' => {'name' => 'sentry',
                   'user' => 'sentry',
                   'password' => 'sentry'},
    'email' => {'host' => 'mail.example.com',
                'user' => 'test@example.com',
                'password' => 'secret',
                'port' => 21,
                'server_email' => 'sentry@example.com'},
    'secret_key' => 'blargleblargle',
    'superuser' => {'username' => 'test',
                    'password' => 'secret',
                    'email' => 'test@example.com'}
  }
)
```

## Attributes

* `sentry['nginx']['domain']`: domain to set. (default: sentry.example.com)
* `sentry['nginx']['port']`: port to list on. (default: 80)
* `sentry['database']['name']`: name of the database to create and use.
* `sentry['database']['user']`: user to own the database.
* `sentry['database']['password']`: password of the user.
* `sentry['email']['host']`: email host to send through.
* `sentry['email']['user']`: user to authenticate against the email host.
* `sentry['email']['password']`: password to authenticate with.
* `sentry['email']['port']`: port to connect on. (default: 25)
* `sentry['email']['use_tls']`: should the connection use TLS? (default: 'True')
* `sentry['email']['server_email']`: the email to send from.
* `sentry['secret_key']`: the secret key to use with Django.
* `sentry['superuser']['username']`: username for the default superuser.
* `sentry['superuser']['email']`: email for the default superuser.
* `sentry['superuser']['password']`: password for the default superuser.

If not otherwise noted, the default values are blank. These values are placed in 
the sentry configuration file (`/etc/sentry/sentry.conf.py`) and so some can be 
Python types.

## Recipes

* `sentry['default']`: installs Sentry with the default configuration.

## Author

Author: Nick Charlton <nick@nickcharlton.net>

[Sentry]: https://github.com/getsentry/sentry
[runit]: https://github.com/hw-cookbooks/runit
[nginx]: https://github.com/opscode-cookbooks/nginx
[postgres]: https://github.com/nickcharlton/postgres-cookbook
[django_key]: http://www.miniwebtool.com/django-secret-key-generator/

