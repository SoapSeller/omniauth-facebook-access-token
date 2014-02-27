# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-facebook-access-token/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'omniauth', '~> 1.2'
  gem.add_dependency 'oauth2', '~> 0.9.3'

  gem.authors       = ["Dor Shahaf"]
  gem.email         = ["dor@shahaf.com"]
  gem.license       = 'MIT'
  gem.description   = %q{A Facebook using access-token strategy for OmniAuth. Can be used for client side Facebook login. }
  gem.summary       = %q{A Facebook using access-token strategy for OmniAuth.}
  gem.homepage      = "https://github.com/soapseller/omniauth-facebook-access-token"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = "omniauth-facebook-access-token"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::FacebookAccessToken::VERSION
end
