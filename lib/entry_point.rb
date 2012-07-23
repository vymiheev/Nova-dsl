$:.push '.', '..'
require 'rubygems'
require "nova-dsl"
require 'logger'
require 'poll_vm'
require 'provision'
require 'transfer'

class EntryPoint
  attr_accessor :name, :image, :flavor, :key

  def initialize(name, image, flavor, key)
    @name=name
    @image=image
    @flavor=flavor
    @key=key
  end

  def bootstrap_vm
    make=Provision.new
    make.run(name,image,flavor,key)
    poller=Poll.new
    vm=poller.poll_vm(name, "active")
    scp=Transfer_package.new("/home/vmiheev/repo/", "/tmp/chucksFiles", vm.ip, "root", ["/home/vmiheev/max.key"], "/home/vmiheev/nova-dsl/nova-dsl/")
    scp.run("/home/vmiheev/repo/chef-project/cookbooks", "java", "chef-jenkins", "apt")
  end
end

entry=EntryPoint.new("gitorious-delete-me", 134, 2, "gs")
entry.bootstrap_vm
