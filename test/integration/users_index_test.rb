require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "users index should include pagination" do
    # Log in as given user
    log_in_as(@user)
    # Visit users index
    get users_path
    # Verify that there's pagination and users' names are displayed
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a', user.name
    end
  end
end
