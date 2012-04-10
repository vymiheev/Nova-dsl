$:.push '.'
require 'common/log'
require 'common/helpers'

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

    def self.fabric(configs = { })
      LOGGER.debug("Fabric new NovaVm class with properties #{configs.inspect}")
      Common::type_checker configs, Hash

    end

  end

  class NovaVmsContainer

    attr_accessor :vms

    def initialize(vms_array = [])
      Common::type_checker vms_array, Array
      vms_array.each { |v| Common::type_checker v, NovaDsl::NovaVm }
      @vms = vms_array
    end

    def [](index)
      raise IndexError("Index #{index} is too large ") unless index < @vms.size
      @vms[index]
    end

    def <<(vm)
      if vm.is_a? NovaDsl::NovaVm;
        @vms << vm
      end
      if vm.is_a? Array;
        @vms += vm
      end
    end

    def merge!(container)
      Common::type_checker container, NovaVmsContainer
      @vms |= container.vms
      self
    end

    def merge(container)
      Common::type_checker container, NovaVmsContainer
      NovaVmsContainer.new( @vms|container.vms )
    end

    def size
      @vms.size
    end

    def find_by_id(id)
      Common::type_checker id, Fixnum
      @vms.select { |v| v.id.eql?(id) }
    end

    def find_by_ip(ip)
      Common::type_checker ip, Fixnum
      @vms.select { |v| v.ip.eql?(ip) }
    end

    def find_by_name(name)
      Common::type_checker name, String
      @vms.select { |v| v.name.eql?(name) }
    end

    def find_by_status(status)
      Common::type_checker status, String
      @vms.select { |v| v.status.eql?(status) }
    end

  end

end