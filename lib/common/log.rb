require "logger"
require "singleton"

module Common

  #Logger singleton wrapper for the project
  class Log

    include Singleton

    @@default_cfg = {
        :level => Logger::DEBUG,
        :device => STDOUT,
        :formatter => "%Y-%m-%dT%H:%M:%S "
    }

    @@cfg = {}

    @@configured = false

    class << self

      def configure(log_cfg = {})
          @@cfg = @@default_cfg.merge(log_cfg)
          @@configured = true

      end

      def new
        super
      end

    end

    def initialize
      reinitialize @@default_cfg.merge(@@cfg)
    end

    def logger
      @logger
    end

    def debug(message=nil, *opts, &block)
      add(Logger::DEBUG, message, nil, opts, &block)
    end

    def info(message=nil, *opts, &block)
      add(Logger::INFO, message, nil, opts, &block)
    end

    def warn(message=nil, *opts, &block)
      add(Logger::WARN, message, nil, opts, &block)
    end

    def error(message=nil, *opts, &block)
      add(Logger::ERROR, message, nil, opts, &block)
    end

    def fatal(message=nil, *opts, &block)
      add(Logger::FATAL, message, nil, opts, &block)
    end

    def unknown(message=nil, *opts, &block)
      add(Logger::UNKNOWN, message, nil, opts, &block)
    end

    def add(severity, message, progname, opts = {}, &block)
      message ||= ''
      raise "You can only pass String or Exception classes as a logger message, you have pass #{message.class}" unless (message.is_a?(String)) || (message.is_a?(Exception))
      progname||=""
      progname[0,0] = ("[%s] " % caller[1]) if opts.include? :line
      use_trace  = opts.include? :trace
      if (message.is_a?(Exception))
        message = "Exception: #{message.class}: #{message.message}"
        message += ", trace: #{message.backtrace}" if use_trace
      end
      if !message.nil? and block_given?
        message<<" "<< (yield).to_s
      end
      @logger.add(severity, message, progname)
    end

    def debug?; @logger.debug? end
    def info?; @logger.info? end
    def level=(val);@logger.level= val end

    def reinitialize(cfg)
      @logger = Logger.new cfg[:device]
      @logger.level= cfg[:level]
      @logger.datetime_format= cfg[:formatter]
    end

    def configure(log_cfg = {})
          @@cfg = @@default_cfg.merge(log_cfg)
          @@configured = true
          reinitialize @@cfg
    end
  end
end

LOGGER = Common::Log.instance
