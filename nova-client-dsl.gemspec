$:.push "."
$:.push File.expand_path("../lib", __FILE__)
require "lib/version"
Gem::Specification.new do |s|
  s.name        = "nova-client-dsl"
  s.version     = NovaDsl::VERSION
  s.authors     = ["gapcoder"]
  s.email       = ["vlaskinvlad@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Dsl wrapper for python nova-client}
  s.description = %q{Call this from a line nova-client}

  s.rubyforge_project = "nova-client-dsl"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.bindir = 'bin'

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end