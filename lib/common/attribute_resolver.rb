require 'common/log'


#Habdles unknown method calls with arguments as variable sets

module Common
  module DefaultAttributeResolver

    def method_missing (name, *args, &script)
      if args[0].nil?
        LOGGER.warn("Attribute '#{name}' is missing, no parameters specified when calling '#{name}'
                      at #{self.class} instance, I'm gonna return 'nil'")
        nil
      else
        LOGGER.debug("Method '#{name}' missing, set new @#{name}: @#{name}=#{args[0]}")
        instance_variable_set("@#{name}".to_sym, args[0])
        self.class.send(:define_method, name, proc { instance_variable_get("@#{name}") })
      end
    end

  end
end