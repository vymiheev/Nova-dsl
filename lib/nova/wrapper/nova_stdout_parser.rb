$:.push '.'
require 'lib/common/log'
require 'lib/common/helpers'
require 'lib/nova/utils/nova_error'
require 'lib/nova/utils/nova_vm'

module NovaDsl

  module NovaStdoutParser
    #Searches ip in the word, that ENDS by ip.
    #Ex: s="fo_my_vm_bar_435.as.341 = 10.3.4.5"
    #The result: s[IP_SEARCHER=~s, s.length] results in `10.3.4.5`

    #TODO: It should supports multiple ips such as: 'private=10.35.9.40, 50.56.54.87'
    IP_SEARCHER=/[a-zA-Z0-9]*(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/


    def parse_nova_list_stdout(stdout)
      LOGGER.debug("Parsing stdout, size: #{stdout.size}")
      Common::type_checker stdout, String

      initial_strings = stdout.split("\n")
      LOGGER.debug("Parsing #{initial_strings.size} lines, assuming first three should be a headers and other stuff")

      vms = NovaDsl::NovaVmsContainer.new

      initial_strings.each_with_index do |line, index|
        columns = line.split("|").map{|s| s.strip}
        if index >=3 && columns.size.eql?(5)
          id = columns[1].to_i
          name = columns[2].to_s
          status = columns[3].capitalize
          ip = columns[4][IP_SEARCHER=~columns[4],columns[4].size]

          vms << NovaDsl::NovaVm.new(id, name, ip, status)
        end
      end
      vms
    end

  end

end