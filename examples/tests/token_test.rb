require 'minitest/autorun'
require 'teth'

class TokenTest < Teth::Minitest
  def test_issue_balance
    assert_equal 0, contract.getBalance(address)
    contract.issue address, 100
    assert_equal 100, contract.getBalance(address)
  end

  def test_issue_exception
    assert_raises(TransactionFailed) { contract.issue Tester::Fixture.accounts[3], 100, sender: Tester::Fixture.keys[4] }
    assert_equal 0, contract.getBalance(Tester::Fixture.accounts[3])
  end

  def test_token_transfer
    contract.issue Tester::Fixture.accounts[2], 100
    contract.transfer Tester::Fixture.accounts[3], 90, sender: Tester::Fixture.keys[2]
    assert_equal 90, contract.getBalance(Tester::Fixture.accounts[3])

    assert_raises(TransactionFailed) { contract.transfer Tester::Fixture.accounts[3], 90, sender: Tester::Fixture.keys[2] }
  end
end
