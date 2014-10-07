class UserMailer < ActionMailer::Base
  default from: "noreply@example.com"

  def account_activation(user)
    # Create an instance variable for use in the view
    @user = user
    mail to: user.email, subject: "Activate your account"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
