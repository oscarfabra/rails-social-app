class Relationship < ActiveRecord::Base

  #----------------------------------------------------------------------------
  # Associations
  #----------------------------------------------------------------------------

  # Belongs to a user as follower
  belongs_to :follower, class_name: "User"
  #Belongs to a user as followed
  belongs_to :followed, class_name: "User"

  #----------------------------------------------------------------------------
  # Validations
  #----------------------------------------------------------------------------

  # follower_id must be present
  validates :follower_id, presence: true
  # followed_id must be preset
  validates :followed_id, presence: true

end
