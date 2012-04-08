$:.push '.'
require "common/log"

module NovaDsl

  #Class NovaVm represents Nova Virtual Machine information
  class NovaVm

    ACTIVE = 'ACTIVE'
    QUEUED = 'QUEUED'

    attr_accessor :id, :name, :status, :ip

    def initialize(id, name, ip = nil, status = nil)
      LOGGER.debug("New NovaVm cerated: id: #{id}, name: #{name}, ip:#{ip}, status: #{status}")
      @id = id
      @name = name
      @ip = ip
      @status = status
    end




  end
end