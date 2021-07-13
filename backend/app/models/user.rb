class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  validates :name,  presence: true,
                    length: { maximum: 20, minimum: 6, allow_blank: true }

  before_save { self.email = email.downcase }
  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255, allow_blank: true },
                    format: { with: valid_email_regex, allow_blank: true },
                    uniqueness: true
end
