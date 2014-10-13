class RelationshipsController < ApplicationController

  #----------------------------------------------------------------------------
  # Validations
  #----------------------------------------------------------------------------
  
  # Requires user to be logged in before any action
  before_action :logged_in_user

  #----------------------------------------------------------------------------
  # Public methods (actions)
  #----------------------------------------------------------------------------

  def create    
    # Finds user to follow
    @user = User.find(params[:followed_id])
    # Follow user
    current_user.follow(@user)
    # Redirects to the other user's profile
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    # Finds user to destroy
    @user = Relationship.find(params[:id]).followed
    # Unfollows user
    current_user.unfollow(@user)
    # Redirects to the other user's profile
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
