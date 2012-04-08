module NovaDsl

  class DslSyntaxError < Exception; end
    class DslMissParameter < DslSyntaxError; end
    class DslMissBody < DslSyntaxError; end

  class NovaCallError < Exception; end
    class NovaProvisionError < NovaCallError; end
end