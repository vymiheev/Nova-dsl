$:.push '.'
require "common/log"
require "common/helpers"
require "lib/nova/nova_error"

module NovaDsl

  module ConsoleWrapper

    def provision(configs = {})

      LOGGER.debug("Call 'nova boot' with parameters :#{configs.inspect}")

      raise NovaDsl::DslMissParameter.new("Missing 'name' attribute when calling provision at wrapper") if configs[:name].nil?
      raise NovaDsl::DslMissParameter.new("Missing 'image' attribute when calling provision at wrapper") if configs[:image].nil?
      raise NovaDsl::DslMissParameter.new("Missing 'flavor' attribute when
                                           calling provision at wrapper") if configs[:flavor].nil?
      raise NovaDsl::DslMissParameter.new("Missing 'key' attribute when calling provision at wrapper") if configs[:key].nil?

      configs[:security_groups] ||= %w(default)

      Common::system_call {
        Kernel::system(
            "nova boot --image #{configs[:image]} --flavor #{configs[:flavor]} --key_name #{configs[:key]} --security_groups #{configs[:security_groups]*','} #{configs[:name]}"
        )
      }
    end

    def list
      LOGGER.debug("Call 'nova list' ")
      Common::system_call(:source => '~/scripts/x25novaDEV.sh') {
        "/usr/local/bin/nova list"
      }
    end

    def delete

    end

    def image_list

    end

    def flavor_list

    end


  end

end