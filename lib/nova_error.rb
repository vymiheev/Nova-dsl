module NovaDsl

  class DslSyntaxError < Exception; end

  class DslMissParameter < DslSyntaxError; end

  class DslMissBody < DslSyntaxError; end


end