#
# Cookbook Name:: sentry
# Recipe:: default
#
# Copyright (c) 2013 Nick Charlton <nick@nickcharlton.net>
# 
# MIT.
#

include_recipe 'postgres'
include_recipe 'runit'

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
python_pip 'sentry[postgres]' do
  user 'sentry'
  group 'sentry'
  virtualenv '/var/www/sentry'
  version '6.3.0'
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
    'secret_key' => node['sentry']['secret_key']
  )
end

# run the sentry migration
# (sentry --config=/etc/sentry.conf.py upgrade)
bash 'sentry database migration' do
  user 'sentry'
  group 'sentry'
  code <<-EOH
. /var/www/sentry/bin/activate &&
/var/www/sentry/bin/python /var/www/sentry/bin/sentry \
--config=/etc/sentry/sentry.conf.py upgrade --noinput &&
deactivate
EOH
end

# configure the superusers
superuser_script = '/tmp/superuser_creator.py'
template superuser_script do
  owner 'sentry'
  group 'sentry'
  source 'superuser_creator.py.erb'

  variables(
    :virtualenv => '/var/www/sentry',
    :config => '/etc/sentry/sentry.conf.py',
    :superuser => node['sentry']['superuser']
  )
end

bash 'create sentry superusers' do
  user 'sentry'
  group 'sentry'

 code <<-EOH
. /var/www/sentry/bin/activate &&
/var/www/sentry/bin/python #{superuser_script} &&
deactivate
EOH
end

file superuser_script do
  action :delete
end

bash 'fix unassigned projects' do
  user 'sentry'
  group 'sentry'

  code <<-EOH
. /var/www/sentry/bin/activate &&
/var/www/sentry/bin/sentry --config=/etc/sentry/sentry.conf.py \
repair --owner=#{node['sentry']['superuser']['username']}
EOH
end

# configure the runit service
runit_service 'sentry' do
  options({
    :root => '/var/www/sentry',
    :user => 'sentry',
    :config => '/etc/sentry/sentry.conf.py'
  })
end

# apply the nginx settings

