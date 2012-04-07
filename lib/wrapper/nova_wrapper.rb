$:.push '.'
require "lib/nova/nova_error"

module NovaDsl

  module Wrapper

    def self.provision(name, image, flavor, key, security_groups = nil)
      raise NovaDsl::DslMissParameter.new("Missing name argument when calling provision at wrapper") if name.nil?
      Kernel::system(
          "nova boot --image #{image} --flavor #{flavor} --key_name #{key} --security_groups #{security_groups*','} #{name}"
      )
    end

    def list

    end

    def delete

    end

    def image_list

    end

    def flavor_list

    end

  end

end