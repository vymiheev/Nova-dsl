$:.push('.')
require "lib/common/log"
require "lib/nova_error"

module NovaDsl

  class Provision

    attr_accessor :image, :flavor

    def initialize(name, &block)
      raise DslMissParameter.new("Missing vm name argument while processing provisioning ") if name.nil?
      raise DslMissBody.new("Missing body do...end while processing provisioning") unless block_given?

      yield(block) if block_given?
    end

  end


end