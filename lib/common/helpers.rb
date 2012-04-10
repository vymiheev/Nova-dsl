  $:.push '.', '..', '../..'
require 'common/log'
require 'open4'


module Common

  # Wraps out the system calls, accepted only 0 results, otherwise NovaCallError raised
  # @param block [Proc] system call 'system' or whateveg
  # @return [Object] console output of the call within block
  def self.system_call(args ={}, &block)

    type_checker args[:source], String
    src = "source #{args[:source]} && " unless args[:source].nil?
    src ||= ''

    result = []
    ok_count = 0
    fail_count = 0

    if block.nil?
      LOGGER.error("'system_call_checker' has received empty block, raising Runtime EX ")
      raise "Empty block has been given to 'system_call_checker'"
    end

    block_commands = yield
    block_commands = block_commands.split("\n").map { |x| x.strip }

    result_stdout = nil
    result_stderr = nil
    proc_pid = nil
    block_commands.each do |cmd|
      composite = src + cmd
      status = Open4::popen4(composite) do |pid, stdin, stdout, stderr|
        LOGGER.debug("Command '#{composite}' is running as pid: #{pid} ")
        proc_pid = pid
        result_stdout = stdout.read.strip
        result_stderr = stderr.read.strip
      end

      LOGGER.debug("Process #{proc_pid} finished, code: #{status.exitstatus}")
      if status.success?; ok_count+=1 else fail_count+=1 end
      LOGGER.error("#{result_stderr}") unless status.success?


      cmd_result = {}
      cmd_result[:status] = status.exitstatus
      cmd_result[:out] = status.success? ? result_stdout : result_stderr

      result << cmd_result
    end
    LOGGER.debug("#{result.size} commands executed, ok: #{ok_count}, failed: #{fail_count}")

    result
  end

  def self.type_checker(value, clazz)
    return value if value.nil?
    raise TypeError.new("Waiting #{clazz} class but received #{value.class} ") unless value.is_a?(clazz)
    value
  end

end