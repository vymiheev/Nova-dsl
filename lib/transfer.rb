require 'rubygems'
require 'net/scp'
require 'logger'
require 'net/ssh'

#ruby, ruby gems, chef-gem and ~/tmp/chucksFiles/ - directory are used to install jenkins on remote vm

class Transfer_package
  LOGGER=Logger.new($stdout)
  ZIP_NAME="cookbook"
  RUN_LIST_NAME="run_list.json"
  CONFIG_NAME="config.rb"
  BASH_SCRIPT="my.sh"

  attr_accessor :initial_path, :remote_path, :ip, :username, :path_to_key, :current_project_path

  def initialize(initial_path, remote_path, ip, username, path_to_key, current_project_path)
    @initial_path=initial_path
    @remote_path=remote_path
    @ip=ip
    @username=username
    @path_to_key=path_to_key
    @current_project_path=current_project_path

  end

  def is_directory?(path)
    (File.exist?(path) && File.directory?(path))
  end

  def is_proper?(path_to_cookbook, recipes)
    if is_directory?(path_to_cookbook)
      LOGGER.info("Cookbook folder is exist! nice-nice.")
      recipes.each do |rec|
        if is_directory?(path_to_cookbook+"/"+rec)
          LOGGER.info("Path to '#{rec}'-recipe is found and ready to use.")
        else
          raise "Houston, we have a problem. Path to recipes does not exist."
        end
      end
    else
      raise "Houston, we have a problem. Cookbook's path does not exist."
    end
  end

  def create_run_list(recipes)
    run_list=File.new(RUN_LIST_NAME, "w")
    run_list.write("{\n\"run_list\": [")
    recipes.each do |rec|
      run_list.write(", ") unless rec.eql?(recipes[0])
      run_list.write("\"recipe[#{rec}]\"")
    end
    run_list.write("]\n}")
    run_list.close
    LOGGER.info "#{RUN_LIST_NAME}-file is created"
  end

  def create_config()
    config_file=File.open("config.rb", "w")
    config_file.write("cookbook_path [\"#{@remote_path+"/chef-project/cookbooks"}\"]\nfile_cache_path \"/tmp/chef-solo\"")
    config_file.close
    LOGGER.info "#{CONFIG_NAME}-file is created"
  end

  def to_zip_run_list(path_to_cookbook)
    system("zip -r #{ZIP_NAME} #{path_to_cookbook}")
    # raise "zip failed" unless $?.success

  end

  def run(path_to_cookbook, *recipes)
    is_proper?(path_to_cookbook, recipes)
    create_system_files(recipes)
    to_zip_run_list(path_to_cookbook)
    prepare_remote_directory
    run_scp
    script="cd /tmp/chucksFiles && unzip #{ZIP_NAME+".zip"} && pwd && mv #{@remote_path+@initial_path+"chef-project/"} #{@remote_path} && /bin/bash #{path_to_cookbook.gsub(@initial_path, "")+"/"+BASH_SCRIPT} && cd #{@remote_path} && pwd && ln -s /var/lib/gems/1.8/gems/chef-10.12.0/bin/chef-solo /usr/bin/ && chef-solo -c #{@remote_path+"/"+CONFIG_NAME} -j #{@remote_path+"/"+RUN_LIST_NAME}"
    run_ssh(script)
    script="chef-solo -c #{@remote_path+"/"+CONFIG_NAME} -j #{@remote_path+"/"+RUN_LIST_NAME}"
    run_ssh(script)
    complete_ssh_session
  end

  def complete_ssh_session
    system("ssh-keygen -R #{@ip}")
  end

  def prepare_remote_directory
    run_ssh("apt-get -y install unzip && rm -rf /tmp/chucksFiles && cd /tmp && mkdir chucksFiles && mkdir chef-solo")

  end

  def create_system_files(recipes)
    create_config()
    create_run_list(recipes)
  end

  def run_scp()
    run_scp_file(@current_project_path+RUN_LIST_NAME)
    run_scp_file(@current_project_path+ZIP_NAME+".zip")
    run_scp_file(@current_project_path+CONFIG_NAME)
  end

  def run_scp_file(local_path)
    Net::SCP.start(@ip, @username, :keys => @path_to_key) do |scp|
      scp.upload!(local_path, @remote_path) do |ch, name, sent, total|
        LOGGER.debug(" '#{name}' : #{sent}/#{total}")
      end
    end
  end

  def run_ssh(script, retry_count = 3, retry_sleep = 15)

    try ||= 0

    begin
    LOGGER.debug(" Starting ssh '#{@username}@#{@ip}'\n} ")
    Net::SSH.start(@ip, @username, :host_key => "ssh-rsa", :keys => @path_to_key, :paranoid => false) do |session|
      LOGGER.debug("Executing commands: '#{script}'")
      #result = session.exec("cd #{@remote_path} && pwd && unzip #{ZIP_NAME+".zip"} && chef-solo -c #{@remote_path+"/"+CONFIG_NAME} -j #{@remote_path+"/"+RUN_LIST_NAME}")

      # cmds.each do |cmd|

      # end
      result = session.exec(script)

      #result = session.exec("cd #{@remote_path} && pwd && chef-solo -c #{@remote_path+"/"+CONFIG_NAME} -j #{@remote_path+"/"+RUN_LIST_NAME}")
      #puts(result)
      LOGGER.debug("Result: #{result}")

    end

    rescue Exception => e
      LOGGER.warn("Caught exc, retrying (count: #{try}) | #{e.class}, #{e.message}")

      try += 1
      sleep(retry_sleep)
      retry if try < retry_count

    end
  end

end
#foo=Transfer_package.new("/home/vmiheev/repo/", "/tmp/chucksFiles", "172.30.6.6", "root", ["/home/vmiheev/max.key"] )
#foo.run("/home/vmiheev/repo/chef-project/cookbooks", "java", "chef-jenkins", "apt")