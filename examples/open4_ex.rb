$:.push '.'
require "common/log"

require "open4"

result_stdout = nil
result_stderr = nil

status = Open4::popen4("env /usr/local/bin/nova list1 ") do |pid, stdin, stdout, stderr|
  result_stdout = stdout.read.strip
  result_stderr = stderr.read.strip
end

puts "status: #{status.inspect}"
puts "exitstatus : #{status.exitstatus}"

puts "stdout: #{result_stdout}" if status.success?
puts "stdout err: #{result_stderr}" unless status.success?