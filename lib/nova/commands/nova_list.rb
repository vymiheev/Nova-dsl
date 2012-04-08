$:.push '.'
require 'lib/common/log'
require 'lib/nova/utils/nova_error'
require 'lib/common/attribute_resolver'
require 'lib/nova/wrapper/nova_console_wrapper'

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
      LOGGER.debug("Returning container size: #{container.size}")
    end

  end
end