require 'teth/minitest'

class <%=name.capitalize%>Test < Teth::Minitest

  def test_something
    assert !contract.address.nil?
  end

end
