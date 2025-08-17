# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  let(:product) { create(:product) }
  let(:valid_attributes) { { name: 'Test Product', description: 'Test Description' } }
  let(:invalid_attributes) { { name: '', description: 'Test Description' } }

  describe 'GET #index' do
    it 'assigns all products as @products' do
      product1 = create(:product)
      product2 = create(:product)
      get :index
      expect(assigns(:products)).to match_array([product1, product2])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'assigns the requested product as @product' do
      get :show, params: { id: product.to_param }
      expect(assigns(:product)).to eq(product)
    end

    it 'renders the show template' do
      get :show, params: { id: product.to_param }
      expect(response).to render_template(:show)
    end

    it 'returns a successful response' do
      get :show, params: { id: product.to_param }
      expect(response).to be_successful
    end

    it 'raises ActiveRecord::RecordNotFound for invalid id' do
      expect do
        get :show, params: { id: 'invalid' }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested product as @product' do
      get :edit, params: { id: product.to_param }
      expect(assigns(:product)).to eq(product)
    end

    it 'renders the edit template' do
      get :edit, params: { id: product.to_param }
      expect(response).to render_template(:edit)
    end

    it 'returns a successful response' do
      get :edit, params: { id: product.to_param }
      expect(response).to be_successful
    end

    it 'raises ActiveRecord::RecordNotFound for invalid id' do
      expect do
        get :edit, params: { id: 'invalid' }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { name: 'Updated Product Name', description: 'Updated Description' } }

      it 'updates the requested product' do
        patch :update, params: { id: product.to_param, product: new_attributes }
        product.reload
        expect(product.name).to eq('Updated Product Name')
        expect(product.description).to eq('Updated Description')
      end

      it 'assigns the product as @product' do
        patch :update, params: { id: product.to_param, product: new_attributes }
        expect(assigns(:product)).to eq(product)
      end

      it 'redirects to the product' do
        patch :update, params: { id: product.to_param, product: new_attributes }
        expect(response).to redirect_to(admin_product_path(product))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the product' do
        original_name = product.name
        patch :update, params: { id: product.to_param, product: invalid_attributes }
        product.reload
        expect(product.name).to eq(original_name)
      end

      it 'assigns the product as @product' do
        patch :update, params: { id: product.to_param, product: invalid_attributes }
        expect(assigns(:product)).to eq(product)
      end

      it 'renders the edit template' do
        patch :update, params: { id: product.to_param, product: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end

    it 'raises ActiveRecord::RecordNotFound for invalid id' do
      expect do
        patch :update, params: { id: 'invalid', product: valid_attributes }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #new' do
    it 'assigns a new product as @product' do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Product' do
        expect do
          post :create, params: { product: valid_attributes }
        end.to change(Product, :count).by(1)
      end

      it 'assigns a newly created product as @product' do
        post :create, params: { product: valid_attributes }
        expect(assigns(:product)).to be_a(Product)
        expect(assigns(:product)).to be_persisted
      end

      it 'redirects to the created product' do
        post :create, params: { product: valid_attributes }
        expect(response).to redirect_to(admin_product_path(Product.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Product' do
        expect do
          post :create, params: { product: invalid_attributes }
        end.not_to change(Product, :count)
      end

      it 'assigns a newly created but unsaved product as @product' do
        post :create, params: { product: invalid_attributes }
        expect(assigns(:product)).to be_a_new(Product)
      end

      it 'renders the new template' do
        post :create, params: { product: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end
end
