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
    chef.run_list = [
        'recipe[sentry]'
    ]
  end
end
