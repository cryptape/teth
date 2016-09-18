require 'teth/minitest'

class MathTest < Teth::Minitest
  def test_add
    assert_equal 3, contract.add(1, 2)
  end
end
