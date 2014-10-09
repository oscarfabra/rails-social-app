require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)    
  end

  test "micropost interface" do
    # Log in and go to the home page
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # Invalid micropost submission
    post microposts_path, micropost: { content: "" }
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room together."
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    # Follow redirect and verify content is displayed in the body
    follow_redirect!
    assert_match content, response.body
    # Delete a post
    assert_select 'a', 'Delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit a different user and verify there's no Delete link
    get user_path(users(:archer))
    assert_select 'a', { text: 'Delete', count: 0 }
  end
end
