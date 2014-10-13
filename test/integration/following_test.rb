require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)    
    @other = users(:archer)
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

  test "should follow a user" do
    # Verify following count increments by one, normal post
    assert_difference '@user.following.count', 1 do
      post relationships_path, followed_id: @other.id
    end
    # Unfollow the other user to restart the test
    @user.unfollow(@other)
    # Verify following count increments by one, xhr post
    assert_difference '@user.following.count', 1 do
      xhr :post, relationships_path, followed_id: @other.id
    end
  end

  test "should unfollow a user" do
    # Verify following count decreases by one, normal post
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), relationship: relationship.id
    end
    # Follow the other user to restart the test
    @user.follow(@other)
    # Verify following count decreases by one, xhr post
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship), relationship: relationship.id
    end
  end
end
