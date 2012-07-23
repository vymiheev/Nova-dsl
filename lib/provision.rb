$:.push '.', '..'
require 'rubygems'
require "nova-dsl"
require 'logger'
require 'timeout'
class Provision
  LOGGER=Logger.new($stdout)

  def run(name, image, flavor, key)
    time_to_wait=30
    begin
      Timeout.timeout(time_to_wait) do
        begin
          NovaDsl::Provision.new(name) {
            image image
            flavor flavor
            key key
          }.run
        rescue Exception => e
          LOGGER.error e.inspect
        end
      end
    rescue Timeout::Error => e
      LOGGER.error "Can not wait forever! #{e.inspect}"
    end
  end
end
