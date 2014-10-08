require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @non_activated_user = users(:user_31)
  end

  test "index as admin including pagination and delete links" do
    # Log in as an admin
    log_in_as(@admin)
    # Visit users index
    get users_path
    # Verify that there's pagination
    assert_select 'div.pagination'
    # Checks first page looking for user names and delete links
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a', user.name
    end
    assert_select 'a', text: 'delete'
    # Selects first user on page and checks that it deletes it
    user = first_page_of_users.first
    assert_difference 'User.count', -1 do
      delete user_path(user)
    end
  end

  test "index as non-admin" do
    # Log in as a non-admin user
    log_in_as(@non_admin)
    # Visits users list and checks there's no delete link
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "non-activated users should not be accessible" do
    # Log in as a non-admin user and visit users list
    log_in_as(@non_admin)
    get users_path
    # Verify non-activated users aren't displayed
    assert_no_match /@non_activated_user.name/i, response.body
    # Visit non-activated user and verify is redirected to root
    get user_path(@non_activated_user.id)
    assert_redirected_to root_url
  end
end
