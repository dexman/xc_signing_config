lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xc_signing_config/version'

Gem::Specification.new do |gem|
  gem.name          = "xc_signing_config"
  gem.version       = XCSigningConfig::VERSION
  gem.authors       = ["Arthur Dexter"]
  gem.email         = ["adexter@gmail.com"]
  gem.description   = %q{Setup for xcodebuild builds using a developerprofile}
  gem.summary       = %q{Setup for xcodebuild builds using a developerprofile}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rubyzip'

  gem.add_development_dependency 'rubygems-tasks'
end
