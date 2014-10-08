class Micropost < ActiveRecord::Base

  # Belongs to a user
  belongs_to :user

  # Order by descending order of created_at
  default_scope -> { order('created_at DESC') }

  # Requires user_id attribute to be present
  validates :user_id, presence: true
  # Content should be present and no greater than 140 charaacters long
  validates :content, presence: true, length: { maximum: 140 }
  
end
