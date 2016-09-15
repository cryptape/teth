require 'teth/minitest'

class TokenTest < Teth::Minitest
  def test_issue_balance
    assert_equal 0, contract.getBalance(address)
    contract.issue address, 100
    assert_equal 100, contract.getBalance(address)
  end

  def test_issue_exception
    assert_raises(TransactionFailed) do
      contract.issue addresses[1], 100, sender: privkeys[2]
    end
    assert_equal 0, contract.getBalance(addresses[1])
  end

  def test_token_transfer
    contract.issue addresses[2], 100
    contract.transfer addresses[3], 90, sender: privkeys[2]
    assert_equal 90, contract.getBalance(addresses[3])

    assert_raises(TransactionFailed) { contract.transfer addresses[3], 90, sender: privkeys[2] }
  end
end
