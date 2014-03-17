Gem::Specification.new do |s|
  s.name        = 'graphunk'
  s.version     = '0.5.1'
  s.date        = '2014-03-16'
  s.summary     = "A funky Ruby library for working with graphs (as related to graph theory)."
  s.description = "This gem defines graph classes which are useful in various mathematical applications."
  s.authors     = ["Evan Hemsley"]
  s.email       = 'evan.hemsley@gmail.com'
  s.files       = Dir.glob("{lib}/**/*") + %w(license.md README.md)
  s.homepage    =
    'https://github.com/ehemsley/graphunk'
  s.license       = 'MIT'

  s.add_dependency 'rspec', '~> 2.14', '>= 2.14.1'
  s.add_development_dependency 'benches', '~> 0.3', '>= 0.3.0'
end
