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

  has_secure_password
  valid_password_regex = /\A[a-zA-Z0-9]+\z/
  validates :password,  presence: true,
                        allow_nil: true,
                        length: { maximum: 32, minimum: 8, allow_blank: true },
                        format: { with: valid_password_regex, allow_blank: true }

  validates :password_confirmation, presence: true
end
