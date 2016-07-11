require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Mock Twitter App"
    assert_equal full_title("Help"), "Help | Mock Twitter App"
  end
end