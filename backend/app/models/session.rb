class Session
  include ActiveModel::Model
  attr_accessor :email, :password, :remember_me

  validate :true_email
  validate :true_password

  private

  def true_email
    if email.blank?
      errors.add(:email, "を入力してください")
    else
      user = User.find_by(email: email)
      return if user

      errors.add(:email, "は正しくありません")
    end
  end

  def true_password
    if password.blank?
      errors.add(:password, "を入力してください")
    else
      user = User.find_by(email: email)
      return if user&.authenticate(password)

      errors.add(:password, "は正しくありません")
    end
  end
end
