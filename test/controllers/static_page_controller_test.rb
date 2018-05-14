require 'test_helper'

class StaticPageControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "FakeTwitter using Ruby on Rails"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | FakeTwitter using Ruby on Rails"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | FakeTwitter using Ruby on Rails"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select 'title', "Contact | FakeTwitter using Ruby on Rails"
  end
end
