class ContactsController < ApplicationController

  # Initializes values for contact form from Contact model
  def new
    @contact = Contact.new
  end

  # Creates and sends the message
  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:notice] = "Thank you for your message. We will contact you soon!"
    else
      flash.now[:error] = "Couldn't send message."
      render :new
    end    
  end
end
