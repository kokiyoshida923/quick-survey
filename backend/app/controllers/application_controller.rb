class ApplicationController < ActionController::API
  include ActionController::Cookies
  before_action :current_user

  def current_user
    return unless (user_id = session[:user_id])

    @current_user ||= User.find_by(id: user_id)
  end
end
