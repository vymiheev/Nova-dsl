$:.push '.'
require "common/log"
require "wrapper/nova_wrapper"

class NovaList

  include NovaDsl::ConsoleWrapper

  def initialize
    LOGGER.debug ("Initiating new nova list")
    list
  end

end