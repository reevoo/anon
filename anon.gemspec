Gem::Specification.new do |s|
  s.name         = 'anon'
  s.version      = '0.0.1' # Using http://semver.org/
  s.date         = '2014-02-03'
  s.summary      = 'Replaces personal data with fake data'
  s.description  = 'Replaces personal data with fake data'
  s.authors      = 'Reevoo Engineering'
  s.email        = 'developers@reevoo.com'
  s.homepage     = 'https://github.com/reevoo/anon'
  s.license      = 'MIT'

  s.files        = Dir.glob('{bin,lib,spec}/**/*.rb')
  s.require_path = 'lib'
  s.executables  = ['anon']

  s.add_runtime_dependency 'time_difference'

  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'reevoocop'
  s.add_development_dependency 'rake'
end
