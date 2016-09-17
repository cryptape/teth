require 'teth/minitest'

class <%=name.capitalize%>Test < Teth::Minitest

  def test_something
    assert_equal false, contract.address.nil?
  end

end
