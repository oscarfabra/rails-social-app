require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)    
    @non_admin = users(:archer)
  end
  
  test "layout links" do
    # Visit root path and verify it shows the home page with its links
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@admin), count: 0
    # Visit sign up page and verify that the correct template is displayed
    get signup_path
    assert_template 'users/new'
    # Visit log in page and verify that the correct template is displayed
    get login_path
    assert_template 'sessions/new'
    # Login and verify that the correct template is displayed
    log_in_as(@admin)
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", user_path(@admin)
    assert_select "a[href=?]", edit_user_path(@admin)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", login_path, count: 0
    # Visit user's edit page and verify that the correct template is displayed
    get edit_user_path(@admin)
    assert_template 'users/edit'
    assert_select 'a', text: 'Change'
    # Visit users list page and verify that the correct template is displayed
    get users_path
    assert_template 'users/index'
    assert_select 'a', text: 'delete' # Admins should find delete links
    delete logout_path                # Logout
    # Login as non-admin, visit users list and verify correct template
    log_in_as(@non_admin)
    follow_redirect!
    get users_path
    assert_select 'a', text: 'delete', count: 0    
  end
end
