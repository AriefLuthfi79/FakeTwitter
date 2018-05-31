require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:arief)
    @other_user = users(:example)    
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect to index when not logged" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow the admin attributes to be edited via the web" do
    log_in_as(@user)
    assert_not @user.admin?
    patch user_path(@user), params: { user: { password: "foobar",
                                                    password_confirmation: "foobar",
                                                    admin: true 
                                                  } }
    assert_not @user.reload.admin?
  end

  test "should redirect when client not logged in" do
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@user)
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
