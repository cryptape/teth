## Introduction
Teth is a Ethereum smart contract test framework in ruby.It provides two testing environments: testing in ruby EVM and testing in geth.You don't need to understand ruby grammar, just enjoy syntactic sugar.

## Dependencies
- Solidity ~> 0.3.6
- Ruby ~> 2.2.2
- Go-ethereum ~> 1.4.11

## Install
```shell
bundle install teth
```

## How to use

Help command:
```
$ teth
```
Create a new Smart Contract application
```
$ teth n project
$ cd project
```
Generate new Smart Contract and test file
```
$ teth g game
```
Run tests
```
$ teth t game
```

## Unit tests
You can wirte fast, simple tests.
```ruby
class TokenTest < Minitest::Test
  include Ethereum

  def setup
    @state = Tester::State.new
    @solidity_code = File.read('./contracts/Token.sol')
    @c = @state.abi_contract @solidity_code, language: :solidity
  end

  def test_issue_balance
    assert_equal 0, @c.getBalance(Tester::Fixture.accounts[2])
    @c.issue Tester::Fixture.accounts[2], 100
    assert_equal 100, @c.getBalance(Tester::Fixture.accounts[2])
  end

  def test_issue_exception
    assert_raises(TransactionFailed) { @c.issue Tester::Fixture.accounts[3], 100, sender: Tester::Fixture.keys[4] }
    assert_equal 0, @c.getBalance(Tester::Fixture.accounts[3])
  end

  def test_token_transfer
    @c.issue Tester::Fixture.accounts[2], 100
    @c.transfer Tester::Fixture.accounts[3], 90, sender: Tester::Fixture.keys[2]
    assert_equal 90, @c.getBalance(Tester::Fixture.accounts[3])

    assert_raises(TransactionFailed) { @c.transfer Tester::Fixture.accounts[3], 90, sender: Tester::Fixture.keys[2] }
  end
end

```
More details:
https://github.com/seattlerb/minitest

## TODO
- Extract test file require and others
- Save migrate address
- Migrate ARGV
- Script for preload
- Easy way to load contract on chain
- Easy way to test on chain
- ES6
