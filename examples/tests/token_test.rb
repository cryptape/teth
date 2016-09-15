require 'teth/minitest'

class TokenTest < Teth::Minitest
  print_logs false
  print_events false

  def test_issue_balance
    assert_equal 0, contract.getBalance(bob)
    contract.issue bob, 100
    assert_equal 100, contract.getBalance(bob)
  end

  def test_issue_exception
    assert_raises(TransactionFailed) do
      contract.issue bob, 100, sender: eve_privkey
    end
    assert_equal 0, contract.getBalance(bob)
  end

  def test_token_transfer
    contract.issue bob, 100
    contract.transfer carol, 90, sender: bob_privkey
    assert_equal 90, contract.getBalance(carol)

    assert_raises(TransactionFailed) { contract.transfer carol, 90, sender: bob_privkey }
  end
end
