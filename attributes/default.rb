#
# Cookbook Name:: sentry
# Attributes:: default
#
# Copyright (c) 2013 Nick Charlton <nick@nickcharlton.net>
# 
# MIT Licensed.
#

default['sentry']['nginx']['domain'] = 'sentry.example.com'
default['sentry']['nginx']['port'] = 80

default['sentry']['database'] = {'name' => '',
                               'user' => '',
                               'password' => ''}

default['sentry']['email'] = {'host' => '',
                              'password' => '',
                              'user' => '',
                              'port' => 25,
                              'use_tls' => 'True',
                              'server_email' => ''}

default['sentry']['secret_key'] = ''


# futher configuration
default['sentry']['email']['backend'] = 'django.core.mail.backends.smtp.EmailBackend'
default['sentry']['email']['backend_package'] = nil

