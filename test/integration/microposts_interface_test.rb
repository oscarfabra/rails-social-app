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
    assert_select 'input[type=file]'
    # Invalid micropost submission
    post microposts_path, micropost: { content: "" }
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room together."
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    assert @user.microposts.first.picture?
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

  test "micropost sidebar count" do
    # User with more than one micropost
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero microposts
    other_user = users(:murray)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    # User with one micropost
    other_user.microposts.create!(content: "A micropost.")
    get root_path
    assert_match "1 micropost", response.body
  end
end
