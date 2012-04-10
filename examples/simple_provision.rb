$:.push '.', '..'
#require 'nova-dsl'
require "lib/nova-dsl"

# Internal dsl example of provisioning new vm

provision "dsl-test" do
  image 999
  flavor 3
  key 'gd1'
  profile '~/scripts/c4gd.sh'
end