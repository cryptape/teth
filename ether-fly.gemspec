Gem::Specification.new do |s|
  s.name        = "ether-fly"
  s.version     = "0.0.1"
  s.authors     = ["Zhang YaNing"]
  s.email       = ["zhangyaning1985@gmail.com"]
  s.homepage    = "https://github.com/u2/ether-fly"
  s.summary     = "Ethereum smart contract test framework."
  s.description = "Ethereum smart contract test framework."
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*"] + ["LICENSE", "README.md"]

  s.add_dependency('ruby-ethereum', '>= 0.9.3')
  s.add_dependency('minitest', '>= 5.8.3')
  s.executables << 'ether-fly'
end
