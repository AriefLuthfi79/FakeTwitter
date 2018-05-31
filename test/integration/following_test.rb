require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:arief)
    @other = users(:adi)
    log_in_as(@user)  
  end
  
  test "following page" do  
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(@user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(@user)
    end
  end

  test "should follow user without ajax" do
    assert_difference "Relationship.count", 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test "should follow user with ajax" do
    assert_difference "Relationship.count", 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  test "should unfollow user without ajax request" do
    @user.follow(@other)
    relation = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference "Relationship.count", -1 do
      delete relationship_path(relation)
    end
  end
  
  test "should unfollow user with ajax" do
    @user.follow(@other)
    relation = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference "Relationship.count", -1 do
      delete relationship_path(relation), xhr: true
    end
  end
end
