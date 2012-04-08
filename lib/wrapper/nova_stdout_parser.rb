$:.push '.'
require "lib/nova/nova_error"

module NovaDsl

  module ParseNovaClient
    #Searches ip in the word, that ENDS by ip.
    #Ex: s="fo_my_vm_bar_435.as.341 = 10.3.4.5"
    #The result: s[IP_SEARCHER=~s, s.length] results in `10.3.4.5`
    IP_SEARCHER=/[a-zA-Z0-9]*(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/


  end

end