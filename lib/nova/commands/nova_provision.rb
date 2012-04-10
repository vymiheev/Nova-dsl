$:.push '.'
require 'lib/common/log'
require 'lib/nova/utils/nova_error'
require 'lib/common/attribute_resolver'
require 'lib/nova/wrapper/nova_console_wrapper'


class << self
  def provision(name, &script)
    NovaDsl::Provision.new(name, &script).run
  end
end

module NovaDsl

  class Provision

    include Common::DefaultAttributeResolver, NovaDsl::NovaConsoleWrapper

    attr_accessor :name

    def initialize(name, &script)
      LOGGER.info("New vm provision, name '#{name}'")
      raise DslMissParameter.new("Missing vm name argument while processing provisioning ") if name.nil?
      raise DslMissBody.new("Missing body do...end while processing provisioning") unless block_given?
      @name = name
      instance_eval &script
      self
    end

    def run
      nova_provision(provision_manifest)
    end

    def provision_manifest
      LOGGER.debug("Checking provision manifest")
      vars = self.instance_variables
      raise DslMissParameter.new("Missing missing parameter 'name'") unless vars.include?(:@name)
      raise DslMissParameter.new("Missing missing parameter 'image'") unless vars.include?(:@image)
      raise DslMissParameter.new("Missing missing parameter 'flavor'") unless vars.include?(:@flavor)
      raise DslMissParameter.new("Missing missing parameter 'key_name'") unless vars.include?(:@key)

      res = {:name => @name, :image => @image, :flavor => @flavor, :key => @key}
      res.merge!(:source => @profile) unless @profile.nil?
      LOGGER.debug("Configuring provision configuration: #{res}")
      res
    end

    def to_s
      "Provision new vm: #{name}, flavor: #{@flavor}, image #{@image} "
    end

  end
end
