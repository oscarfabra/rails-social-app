require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  
  # Include ApplicationHelper to access its helper methods
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    # Visit the user profile
    get user_path(@user)
    assert_select 'title', full_title(@user.name)
    # The user's name, image, microposts' count are in the HTML body
    assert_match @user.name, response.body
    assert_select 'img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    # and there's pagination of microposts
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    # The user stats are present in the HTML
    assert_select 'section.stats'
    assert_match @user.following.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body
  end
end
