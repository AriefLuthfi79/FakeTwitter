require 'test_helper'

class MicropostInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:arief)
  end
  
  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type="file"]'
    # Invalid submission
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # Valid submisssion
    content = "Lorem ipsum sit atmet"
    image = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost: { content: content, picture: image } }
    end
    assert assigns(:micropost).picture?
    
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete Post
    assert_select 'a', text: 'delete'
    first_posting = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_posting)
    end
    
    # Visit diferent user (automated no delete links)
    get user_path(users(:example))
    assert_select 'a', text: "delete", count: 0
  end

  # test "micropost sidebar count" do
  #   log_in_as(@user)
  #   get root_path
  #   assert_match "#{@user.microposts.count} microposts", response.body
  #   User with zero micropost
  #   other_user = users(:example)
  #   log_in_as(other_user)
  #   get root_path
  #   assert_match "0 micropost", response.body
  #   other_user.microposts.create!(content: "Lorem ipsum sit amet")
  #   get root_path
  #   assert "#{other_user.microposts.count} micropost", response.body
  # end
end
