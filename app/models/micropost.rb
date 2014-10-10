class Micropost < ActiveRecord::Base

  #----------------------------------------------------------------------------
  # Associations
  #----------------------------------------------------------------------------

  # Belongs to a user
  belongs_to :user
  
  #----------------------------------------------------------------------------
  # Attributes (additional to the database model)
  #----------------------------------------------------------------------------

  # Scope to order by descending order of created_at
  default_scope -> { order('created_at DESC') }
  # Uploads images
  mount_uploader :picture, PictureUploader

  #----------------------------------------------------------------------------
  # Validations
  #----------------------------------------------------------------------------

  # Requires user_id attribute to be present
  validates :user_id, presence: true
  # Content should be present and no greater than 140 charaacters long
  validates :content, presence: true, length: { maximum: 140 }
  # Validaates picture size before create.
  validate :picture_size

  #----------------------------------------------------------------------------
  # Private methods
  #----------------------------------------------------------------------------
  
  private

    # Determines whether picture as less than 1 MB.
    def picture_size
      if picture.size > 1.megabyte
        errors.add(:picture, "should be less than 1MB")
      end      
    end
end
