$:.push '.', '..'
require "lib/common/log"
require "lib/nova/nova_error"

class Provision

  attr_accessor :name

  def initialize(name, &script)
    LOGGER.info("New vm provision, name '#{name}'")
    raise DslMissParameter.new("Missing vm name argument while processing provisioning ") if name.nil?
    raise DslMissBody.new("Missing body do...end while processing provisioning") unless block_given?
    @name = name
    instance_eval &script
  end

  def method_missing (name, *args, &script)
    if args[0].nil?
      LOGGER.warn("Attribute '#{name}' is missing, no parameters specified when calling '#{name}'
                  at #{self.class} instance, I'm gonna return 'nil'" )
      nil
    else
      LOGGER.debug("Method '#{name}' missing, set new @#{name}: @#{name}=#{args[0]}")
      instance_variable_set("@#{name}".to_sym, args[0])
      self.class.send(:define_method, name, proc { instance_variable_get("@#{name}") })
    end
  end

  def to_s
    "Provision new vm: #{name}, flavor: #{@flavor}, image #{@image} "
  end

end
