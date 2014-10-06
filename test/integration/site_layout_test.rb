require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)    
  end
  
  test "layout links for non-logged-in users" do
    # Visit root path and verify it shows the home page with its links
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    # Visit users path, follow redirect to login, and verify template
    get users_path
    follow_redirect!
    assert_template 'users/new'
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    # TODO: Visit other templates...
  end

  test "layout links for logged-in users" do
    # Log in as a user and verify it shows the profile page
    log_in_as(@user)
    assert_template 'users/new'
    # TODO: Visit other templates...
  end
end
