$:.push '.', '..', File.expand_path("lib", __FILE__)

require 'common/log'
require 'nova/commands/nova_provision'
require 'nova/commands/nova_list'
require 'entry_point'

