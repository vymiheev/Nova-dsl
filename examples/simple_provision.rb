$:.push '.', '..'
gem 'nova-dsl'
require '../lib/nova_wrapper'

NovaDsl::Provision.new "my new name" do
  ap 'Hellow world'
end
