Gem::Specification.new do |s|
  s.name        = "teth"
  s.version     = "0.1.0"
  s.authors     = ["Zhang YaNing", "Jan Xie"]
  s.email       = ["zhangyaning1985@gmail.com", "jan.h.xie@gmail.com"]
  s.homepage    = "https://github.com/cryptape/teth"
  s.summary     = "Testing and deployment framework for Ethereum smart contracts."
  s.description = "Teth is a Ethereum smart contract test framework in ruby. It provides two testing environments: testing in ruby EVM and testing in geth. You don't need to understand ruby grammar, just enjoy syntactic sugar."
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*"] + ["LICENSE", "README.md"]

  s.add_dependency('ruby-ethereum', '~> 0.9')
  s.add_dependency('minitest', '~> 5.8')
  s.executables << 'teth'
end
