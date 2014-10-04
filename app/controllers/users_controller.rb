class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # debugger
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # Uses user_params private method
    if @user.save                 # If user successfully created
      log_in @user                # Logs in the user by default
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user           # Same as user_url(@user), rails infers it
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

  # Private methods
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, 
        :password_confirmation)
    end
end
