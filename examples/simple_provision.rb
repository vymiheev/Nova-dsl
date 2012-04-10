$:.push '.', '..'

require 'nova-dsl'
provision "dsl-test" do
  image 999
  flavor 3
  key 'gd1'
end