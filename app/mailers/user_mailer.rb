class UserMailer < ActionMailer::Base
  default from: "noreply@herokuapp.com"

  # Create an instance variable for use in the view
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Activate your account"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Reset your password"
  end
end
