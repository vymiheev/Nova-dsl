$:.push '.'
require 'common/log'
require 'nova/utils/nova_error'
require 'common/attribute_resolver'
require 'nova/wrapper/nova_console_wrapper'

class << self
  def nova_list(&script)
    NovaDsl::NovaList.new(&script).run
  end
end

module NovaDsl
  class NovaList


    include NovaDsl::NovaConsoleWrapper

    def initialize(&script)
      LOGGER.debug ("Initiating new nova list")
    end

    def run
      container = nova_list
    end

  end
end