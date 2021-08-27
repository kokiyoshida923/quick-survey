module Api
  module V1
    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:index, :edit, :update]
      before_action :correct_user, only: [:edit, :update]

      def index
        users = User.all.order(created_at: :DESC)
        render json: { users: users }
      end

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
          session[:user_id] = user.id
          render json: { user: user }
        else
          errors = user.errors.full_messages
          render json: { errors: errors }
        end
      end

      def edit
        user = User.find(params[:id])
        render json: { user: user }
      end

      def update
        user = User.find(params[:id])
        if user.update(user_params)
          render json: { user: user }
        else
          errors = user.errors.full_messages
          render json: { errors: errors }
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
      end

      def logged_in_user
        return if @current_user

        render status: :forbidden, json: { message: "ユーザーがログインしていません" }
      end

      def correct_user
        user = User.find(params[:id])
        render status: :forbidden, json: { message: "ユーザーが正しくありません" } unless user == @current_user
      end
    end
  end
end
