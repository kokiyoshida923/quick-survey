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
        unauth_user = Session.new(email: nil, password: nil, remember_me: nil)
        render json: { unauth_user: unauth_user }
      end

      def create
        unauth_user = Session.new(session_params)
        if unauth_user.valid?
          auth_user = User.find_by(email: params[:session][:email].downcase)
          session[:user_id] = auth_user.id
          params[:session][:remember_me] == "1" ? remember(auth_user) : forget(auth_user)
          render json: { auth_user: auth_user }
        else
          errors = unauth_user.errors.full_messages
          render json: { errors: errors }
        end
      end

      def destroy
        return unless @current_user

        forget(@current_user)
        session.delete(:user_id)
        @current_user = nil
      end

      private

      def session_params
        params.require(:session).permit(:email, :password, :remember_me)
      end

      def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
      end

      def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
      end
    end
  end
end
