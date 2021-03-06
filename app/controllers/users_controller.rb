class UsersController < ApplicationController

  #----------------------------------------------------------------------------
  # Validations
  #----------------------------------------------------------------------------

  # Requires user to be logged in before several actions
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, 
    :following, :followers]
  # Requires the correct user before edit or update actions
  before_action :correct_user, only: [:edit, :update]
  # Requires user to be admin before destroy action
  before_action :admin_user, only: :destroy


  #----------------------------------------------------------------------------
  # Public methods (actions)
  #----------------------------------------------------------------------------

  def index
    # Displays only activated users
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
    # debugger
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # Uses user_params private method
    if @user.save                 # If user successfully created
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else                          # If invalid sign up, redirects to same page
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])    
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  #----------------------------------------------------------------------------
  # Private methods
  #----------------------------------------------------------------------------

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, 
        :password_confirmation)
    end

    # Before filters

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      # Redirects user to login if not the correct user
      # Calls sessions helper method
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms and admin user.
    def admin_user
      # Redirects user to login if not an admin
      redirect_to(root_url) unless current_user.admin?
    end
end
