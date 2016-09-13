Gem::Specification.new do |s|
  s.name        = "ether-fly"
  s.version     = "0.0.1"
  s.authors     = ["Zhang YaNing"]
  s.email       = ["zhangyaning1985@gmail.com"]
  s.homepage    = "https://github.com/u2/ether-fly"
  s.summary     = "Ethereum smart contract test framework."
  s.description = "EtherFly is a Ethereum smart contract test framework in ruby.I provide test in ruby EVM and geth test two styles."
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*"] + ["LICENSE", "README.md"]

  s.add_dependency('ruby-ethereum', '~> 0.9')
  s.add_dependency('minitest', '~> 5.8')
  s.executables << 'ether-fly'
end
