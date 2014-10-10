class MicropostsController < ApplicationController

  # Requires user to be logged in for create and destroy actions
  before_action :logged_in_user, only: [:create, :destroy]

  # Requires correct user for destroy action
  before_action :correct_user, only: :destroy

  def create   
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted."
    redirect_to request.referrer || root_url
  end

  # Private methods
  private

    # Uses strong parameters for building a micropost.
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    # Decides whether user is the creator of micropost.
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])      
      redirect_to root_url if @micropost.nil?
    end
end
