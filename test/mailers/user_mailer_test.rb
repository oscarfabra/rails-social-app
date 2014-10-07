require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = User.create(name: "Test User", email: "test@example.com", password: "foobarbaz",
      password_confirmation: "foobarbaz" )
    mail = UserMailer.account_activation(user)
    assert_equal "Activate your account", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end
end
