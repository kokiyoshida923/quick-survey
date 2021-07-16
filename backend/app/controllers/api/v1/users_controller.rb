module Api
  module V1
    class UsersController < ApplicationController
      def show
        user = User.find(params[:id])
        render json: { user: user }
      end

      def new
        user = User.new
        render json: { user: user }
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: { user: user }
        else
          errors = user.errors.full_messages
          render json: { errors: errors }
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
