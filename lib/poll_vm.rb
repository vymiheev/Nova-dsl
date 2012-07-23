$:.push '.', '..'
require 'rubygems'
require "nova-dsl"
require 'logger'
require 'timeout'

class Poll
  LOGGER=Logger.new($stdout)
  BUILD_STATUS="BUILD"

  def poll_vm(vm_name, status)
    time_to_wait = 60
    begin
      Timeout.timeout(time_to_wait) do
        loop {
          vm_list = NovaDsl::NovaList.new.run
          vms = vm_list.find_by_name(vm_name)
          return vms[0] if (!vms[0].nil? && vms[0].status.downcase.eql?(status.downcase) )
          sleep(5)
        }
      end
      #

      #  # vms_arr = vms.vms
      #
      #  i=0
      #  while i<vms.size
      #    if vms[i].name.to_s.eql?(vm_name)
      #      LOGGER.debug "'#{vm_name}' is found!"
      #      loop {
      #        if vms[i].status.to_s.downcase.eql?(status.downcase)
      #          LOGGER.info("Here is your VM:\nid: #{vms[i].id}\nip: #{vms[i].ip}\nname: #{vms[i].name}\nstatus: #{vms[i].status}")
      #          return vms[i]
      #        else
      #          if vms[i].status.to_s.eql?(BUILD_STATUS)
      #            sleep(5)
      #            LOGGER.debug("waiting while #{vm_name} activate")
      #          end
      #        end
      #      }
      #    end
      #    i+=1
      #  end
      #  raise Exception.new "Any #{status} #{vm_name} wasn't found!"
      #end
    end
  rescue Timeout::Error => e
    raise "Can not wait forever! #{e.inspect}"

  end
end
#foo = Poll.new
#b00 = foo.poll_vm("gitorious-repo", "active")