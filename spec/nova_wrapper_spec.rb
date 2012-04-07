$:.push '.'

require 'rspec'

require 'lib/wrapper/nova_wrapper'


describe NovaDsl::Wrapper do

  before :each do
    @wrapper = NovaDsl::Wrapper

    @name = 'foo_vm'
    @flavor = 3
    @image = 543
    @key = 'gd_test.key'
    @security_groups = ['default', 'allowall', 'apache']

  end

  it "should be able to provision vm" do
    Kernel.stub!(:system)
    Kernel.should_receive(:system).once.and_return(true)
    @wrapper.provision(@name, @image, @flavor, @key, @security_groups)
  end

  it "should raise error when accepting nil args"

  it "should get list of provisioned vms"

  it "should get flavor list"

  it "should get image list"

  it "should get instance info"

  it "should delete vm by it's id"

  it "should register additional names in dns"

  it "should be able to check vm ping is ok"

  it "should check vm port 22 is accessible"

  it "should check vm is accessible by ssh"

end