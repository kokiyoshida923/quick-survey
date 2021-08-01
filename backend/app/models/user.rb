class User < ApplicationRecord
  attr_accessor :remember_token

  mount_uploader :avatar, AvatarUploader

  validates :name,  presence: true,
                    length: { maximum: 20, minimum: 6, allow_blank: true }

  before_save { self.email = email.downcase }
  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255, allow_blank: true },
                    format: { with: valid_email_regex, allow_blank: true },
                    uniqueness: true

  has_secure_password validations: false
  validate do |record|
    record.errors.add(:password, :blank) unless record.password_digest.present?
  end
  validate(on: :update) do |record|
    record.errors.add(:password, :blank) if record.password_digest.present? && self.password.nil?
  end
  valid_password_regex = /\A[a-zA-Z0-9]+\z/
  validates :password,  presence: true,
                        allow_nil: true,
                        length: { maximum: 32, minimum: 8, allow_blank: true },
                        format: { with: valid_password_regex, allow_blank: true }
  validates_confirmation_of :password, allow_blank: true

  validates :password_confirmation, presence: true

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    assign_attributes({ remember_digest: User.digest(self.remember_token) })
    save(validate: false)
  end

  def authenticated?(remember_token)
    return false if self.remember_digest.nil?

    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

  def forget
    assign_attributes({ remember_digest: nil })
    save(validate: false)
  end
end
