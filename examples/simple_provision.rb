$:.push '.', '..'
#require 'nova-dsl'
require "lib/nova-dsl"
require 'ap'

# Internal dsl example of provisioning new vm
nova_provision "jenkins" do
  image 543
  flavor 4
  key "gd1"
  dns_name "jenkins"
  security_groups ['deafult', 'noname']
end

