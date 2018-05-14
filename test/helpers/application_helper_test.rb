require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "full title helper" do
    assert_equal full_title, "FakeTwitter using Ruby on Rails"
    assert_equal full_title("About"), "About | FakeTwitter using Ruby on Rails"
    assert_equal full_title("Help"), "Help | FakeTwitter using Ruby on Rails"
    assert_equal full_title("Contact"), "Contact | FakeTwitter using Ruby on Rails"
  end
end