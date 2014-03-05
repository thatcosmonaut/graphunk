Gem::Specification.new do |s|
  s.name        = 'graphunk'
  s.version     = '0.3.0'
  s.date        = '2014-03-04'
  s.summary     = "A funky Ruby library for working with graphs (as related to graph theory)."
  s.description = "This gem defines graph classes which are useful in various mathematical applications."
  s.authors     = ["Evan Hemsley"]
  s.email       = 'evan.hemsley@gmail.com'
  s.files       = Dir.glob("{lib}/**/*") + %w(license.md README.md)
  s.homepage    =
    'https://github.com/ehemsley/graphunk'
  s.license       = 'MIT'
end
