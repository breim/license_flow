# frozen_string_literal: true

module Admin
  class SubscriptionsController < Admin::AdminController
    before_action :set_subscription, only: %i[edit update destroy]
    before_action :set_account
    before_action :set_products, only: %i[new create edit update]

    def edit; end

    def update
      @subscription.update(subscription_params)
      respond_with(:admin, @account, @subscription, location: admin_account_path(@account))
    end

    def new
      @subscription = Subscription.new
    end

    def create
      @subscription = Subscription.new(subscription_params)
      @subscription.account_id = @account.id
      @subscription.save
      respond_with(:admin, @account, @subscription, location: admin_account_path(@account))
    end

    def destroy
      @subscription.destroy
      respond_with(:admin, @account, location: admin_account_path(@account))
    end

    private

    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def set_account
      @account = Account.find(params[:account_id])
    end

    def set_products
      @products = Product.all
    end

    def subscription_params
      params.require(:subscription).permit(:product_id, :number_of_licenses,
                                           :issued_at, :expires_at)
    end
  end
end
