# frozen_string_literal: true

module Admin
  class AccountsController < Admin::AdminController
    before_action :set_account, only: %i[show edit update]

    def index
      @accounts = Account.all
    end

    def show; end

    def edit; end

    def update
      @account.update(account_params)
      respond_with(:admin, @account)
    end

    def new
      @account = Account.new
    end

    def create
      @account = Account.new(account_params)
      @account.save
      respond_with(:admin, @account)
    end

    private

    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name)
    end
  end
end
