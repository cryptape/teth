## Introduction
EtherFly is a Ethereum smart contract test framework in ruby.It provides two testing environments: testing in ruby EVM and testing in geth.You don't need to understand ruby grammar, just enjoy syntactic sugar.

## Install
```shell
bundle install ether-fly
```

## How to use

Help command:
```
$ ether-fly
```
Create a new Smart Contract application
```
$ ether-fly n project
$ cd project
```
Generate new Smart Contract and test file
```
$ ether-fly g game
```
Run tests
```
$ ether-fly t game
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
