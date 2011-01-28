require 'test_helper'

class PrivateIdDefinitionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert PrivateIdDefinition.new.valid?
  end
end
