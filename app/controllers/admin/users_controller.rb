# frozen_string_literal: true

module Admin
  class UsersController < Admin::AdminController
    before_action :set_user, only: %i[show edit update]

    def index
      @users = User.all
    end

    def show; end

    def edit; end

    def update
      @user.update(user_params)
      respond_with(:admin, @user)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.save
      respond_with(:admin, @user)
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :account_id)
    end
  end
end
