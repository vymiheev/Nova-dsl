$:.push '.'
require 'lib/common/log'
require 'lib/common/helpers'
require 'lib/nova/utils/nova_error'
require 'lib/nova/wrapper/nova_stdout_parser'
require 'lib/nova/utils/nova_vm'

module NovaDsl

  module NovaConsoleWrapper

    include NovaDsl::NovaStdoutParser

    def nova_provision(configs = {})
      LOGGER.debug("Call 'nova boot' with parameters :#{configs.inspect}")
      raise NovaDsl::DslMissParameter.new("Missing 'name' attribute when calling provision at wrapper") if configs[:name].nil?
      Common::
          raise NovaDsl::DslMissParameter.new("Missing 'image' attribute when calling provision at wrapper") if configs[:image].nil?
      raise NovaDsl::DslMissParameter.new("Missing 'flavor' attribute when
                                           calling provision at wrapper") if configs[:flavor].nil?
      raise NovaDsl::DslMissParameter.new("Missing 'key' attribute when calling provision at wrapper") if configs[:key].nil?

      configs[:security_groups] ||= %w(default)

      configs[:source] ||= ''

      Common::system_call(:source => configs[:source]){
        "/usr/local/bin/nova boot --image #{configs[:image]} --flavor #{configs[:flavor]} --key_name #{configs[:key]} --security_groups #{configs[:security_groups]*','} #{configs[:name]}"

      }
    end

    def nova_list
      LOGGER.debug("Call 'nova list' ")
      results = Common::system_call(:source => '~/scripts/x25novaDEV.sh') {
        "/usr/local/bin/nova list"
      }

      vms = NovaDsl::NovaVmsContainer.new

      results.each do |result|
        if result[:status].eql?(0)
        vms.merge!(parse_nova_list_stdout result[:out])
        else
          LOGGER.debug("Skipping command stdout parsing because exitstatus is #{result[:status]}")
        end
      end
      vms
    end

    def nova_delete

    end

    def nova_image_list

    end

    def nova_flavor_list

    end


  end

end