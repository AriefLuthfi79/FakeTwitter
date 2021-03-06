require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Example", email: "example@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end

  test "user name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "user email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "email validation should accept valid adresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should be invalid"
    end
  end

  test "email should be unique and cannot be duplicate" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be downcase before saving to database" do
    mixed_case_email = "ExaMple@gMAIl.coM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase!, @user.reload.email
  end

  test "password should be present and cannot be blank" do
    @user.password = " " * 6
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = " " * 4
    assert_not @user.valid?
  end

  test "authenticated method should be return false with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow user" do
    arief = users(:arief)
    example = users(:example)
    assert_not arief.following?(example)
    arief.follow(example)
    assert example.followers.include? arief
    arief.unfollow(example)
    assert_not arief.following? example
  end

  test "feed should have the right posts" do
    arief = users(:arief)
    example = users(:example)
    lana = users(:lana)
    # Posts from followed users
    lana.microposts.each do |post_following|
      assert arief.feed.include?(post_following)
    end
    # Posts from self
    arief.microposts.each do |post_self|
      assert arief.feed.include?(post_self)
    end
    # Posts from unfollowed user
    example.microposts.each do |unfollow_post|
      assert_not arief.feed.include?(unfollow_post)
    end
  end
end
