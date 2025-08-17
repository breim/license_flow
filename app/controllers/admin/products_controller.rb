# frozen_string_literal: true

module Admin
  class ProductsController < Admin::AdminController
    before_action :set_product, only: %i[show edit update]

    def index
      @products = Product.all
    end

    def show; end

    def edit; end

    def update
      @product.update(product_params)
      respond_with(:admin, @product)
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      @product.save
      respond_with(:admin, @product)
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description)
    end
  end
end
