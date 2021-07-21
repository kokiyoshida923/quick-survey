module Api
  module V1
    class SessionsController < ApplicationController
      def verification
        if @current_user
          render json: { is_authenticated: true, auth_user: @current_user }
        else
          render json: { is_authenticated: false }
        end
      end

      def new
        unauth_user = Session.new(email: nil, password: nil)
        render json: { unauth_user: unauth_user }
      end

      def create
        unauth_user = Session.new(session_params)
        if unauth_user.valid?
          auth_user = User.find_by(email: params[:session][:email].downcase)
          session[:user_id] = auth_user.id
          render json: { auth_user: auth_user }
        else
          errors = unauth_user.errors.full_messages
          render json: { errors: errors }
        end
      end

      private

      def session_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
