#
# Cookbook Name:: sentry
# Recipe:: default
#
# Copyright (c) 2013 Nick Charlton <nick@nickcharlton.net>
# 
# MIT.
#

include_recipe 'postgres'

# create a user to run the daemon as
user 'sentry' do
  home '/home/sentry'
  shell '/bin/bash'
  comment 'User for handling the Sentry application'
  system true
  supports :manage_home => true

  action :create
end

# create the application directories
directory '/var/www/sentry' do
  owner 'sentry'
  group 'sentry'
  mode '0750'
  recursive true
end

directory '/etc/sentry' do
  owner 'sentry' # should be root by with read ability when configured through here
  group 'sentry'
  mode '0750'
end

# create the postgres user and database
pg_user "#{node['sentry']['database']['user']}" do
  privileges superuser: false, createdb: false, login: true

  password "#{node['sentry']['database']['password']}"
end

pg_database "#{node['sentry']['database']['name']}" do
  owner "#{node['sentry']['database']['user']}"
  encoding 'utf8'
  template 'template0'
  locale 'en_US.UTF8'
end

# create the virtualenv
python_virtualenv '/var/www/sentry' do
  owner 'sentry'
  group 'sentry'
  action :create
end

# install sentry
%w{sentry[postgres]}.each do |pip|
  python_pip pip do
    user 'sentry'
    group 'sentry'
    virtualenv '/var/www/sentry'
  end
end

# set the configuration file
template '/etc/sentry/sentry.conf.py' do
  source 'sentry.conf.py.erb'
  owner 'sentry'
  group 'sentry'
  mode '0770'

  variables(
    'database' => node['sentry']['database'],
    'email' => node['sentry']['email'],
    'secret_key' => ndoe['sentry']['secret_key']
  )
end

# run the sentry migration

# configure the superusers

# configure the web server

# apply the nginx settings

