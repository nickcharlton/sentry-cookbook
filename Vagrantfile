# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.hostname = 'sentry-berkshelf'
  config.vm.box = 'boxes-precise64-chef'
  config.vm.box_url = 'http://nickcharlton-boxes.s3.amazonaws.com/precise64-chef-virtualbox.box'

  # create a private network to interact with it
  config.vm.network :private_network, ip: '10.0.0.11'

  # enable Berkshelf
  config.berkshelf.enabled = true

  # provision using Chef Solo
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      'sentry' => {
        'nginx' => {
          'domain' => 'sentry.example.com'
        },
        'database' => {
          'name' => 'sentry',
          'user' => 'sentry',
          'password' => 'sentry'
        },
        'email' => {
          'host' => 'mail.example.com',
          'password' => 'secret',
          'user' => 'sentry',
          'server_email' => 'sentry@example.com'
        },
        'secret_key' => 'sn!h+0%cr=0qx37*i1gu)n*v0r3n8jzt@c5o5j8+85num#vx-c',
        'superuser' => {
          'username' => 'test',
          'password' => 'password',
          'email' => 'test@example.com'
        }
      }
    }

    chef.run_list = [
        'recipe[python]',
        'recipe[runit]',
        'recipe[postgres::server]',
        'recipe[nginx]',
        'recipe[sentry]'
    ]
  end
end
