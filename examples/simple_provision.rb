$:.push '.', '..'
#require 'nova-dsl'
require "lib/nova-dsl"

# Internal dsl example of provisioning new vm
Provision.new "my new name" do
  image 543
  flavor 3
  dns_name "test.xcom.me"
end
