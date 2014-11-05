class Contact < MailForm::Base
  attribute :name, :validate => true
  attribute :email, :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message
  attribute :nickname, :captcha  => true

  # Defines the contact headers
  def headers
    {
      :subject => "New Message from Rails Social App",
      :to => "oscarfabra@hotmail.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end
