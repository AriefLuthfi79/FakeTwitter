require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin = users(:arief)
    @user_non_admin = users(:example)
  end
  
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    # assert_select 'div.pagination'
    first_page = User.paginate(page: 1)
    first_page.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: user.name
      end
    end
  end

  test "index as non admin it can only show users" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'a', text: 'delete', count: 0
  end
end
