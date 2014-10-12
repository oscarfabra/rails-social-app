require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)    
    log_in_as(@user)
  end

  test "following page" do
    # Visit followings page of user
    get following_user_path(@user)
    # Verify that number of following appears
    assert_match @user.following.count.to_s, response.body
    # Verify each followed has a link to his/her profile
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    # Visit followers page of user
    get followers_user_path(@user)
    # Verify that number of followers appears
    assert_match @user.followers.count.to_s, response.body
    # Verify each follower has a link to his/her profile
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end  
end
