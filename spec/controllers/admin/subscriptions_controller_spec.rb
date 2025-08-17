# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SubscriptionsController, type: :controller do
  let(:account) { create(:account) }
  let(:product) { create(:product) }
  let(:subscription) { create(:subscription, account: account, product: product) }
  let(:valid_attributes) do
    {
      product_id: product.id,
      number_of_licenses: 10,
      issued_at: Date.current,
      expires_at: 1.year.from_now
    }
  end
  let(:invalid_attributes) do
    {
      product_id: nil,
      number_of_licenses: nil,
      issued_at: nil,
      expires_at: nil
    }
  end

  describe 'GET #new' do
    before { get :new, params: { account_id: account.to_param } }

    it 'assigns a new subscription as @subscription' do
      expect(assigns(:subscription)).to be_a_new(Subscription)
    end

    it 'assigns all products as @products' do
      expect(assigns(:products)).to eq(Product.all)
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new subscription' do
        expect do
          post :create, params: { account_id: account.to_param, subscription: valid_attributes }
        end.to change(Subscription, :count).by(1)
      end

      it 'assigns the newly created subscription as @subscription' do
        post :create, params: { account_id: account.to_param, subscription: valid_attributes }
        expect(assigns(:subscription)).to be_a(Subscription)
        expect(assigns(:subscription)).to be_persisted
      end

      it 'sets the account_id for the subscription' do
        post :create, params: { account_id: account.to_param, subscription: valid_attributes }
        expect(assigns(:subscription).account_id).to eq(account.id)
      end

      it 'assigns all products as @products' do
        post :create, params: { account_id: account.to_param, subscription: valid_attributes }
        expect(assigns(:products)).to eq(Product.all)
      end

      it 'redirects to the account' do
        post :create, params: { account_id: account.to_param, subscription: valid_attributes }
        expect(response).to redirect_to(admin_account_path(account))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new subscription' do
        expect do
          post :create, params: { account_id: account.to_param, subscription: invalid_attributes }
        end.not_to change(Subscription, :count)
      end

      it 'assigns a newly created but unsaved subscription as @subscription' do
        post :create, params: { account_id: account.to_param, subscription: invalid_attributes }
        expect(assigns(:subscription)).to be_a_new(Subscription)
      end

      it 'assigns all products as @products' do
        post :create, params: { account_id: account.to_param, subscription: invalid_attributes }
        expect(assigns(:products)).to eq(Product.all)
      end

      it 'returns unprocessable content status' do
        post :create, params: { account_id: account.to_param, subscription: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { account_id: account.to_param, id: subscription.to_param } }

    it 'assigns the requested subscription as @subscription' do
      expect(assigns(:subscription)).to eq(subscription)
    end

    it 'assigns all products as @products' do
      expect(assigns(:products)).to eq(Product.all)
    end

    it 'renders the edit template' do
      expect(response).to render_template(:edit)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          number_of_licenses: 20,
          expires_at: 2.years.from_now
        }
      end

      it 'updates the requested subscription' do
        patch :update, params: { account_id: account.to_param, id: subscription.to_param, subscription: new_attributes }
        subscription.reload
        expect(subscription.number_of_licenses).to eq(20)
      end

      it 'assigns the subscription as @subscription' do
        patch :update, params: { account_id: account.to_param, id: subscription.to_param, subscription: new_attributes }
        expect(assigns(:subscription)).to eq(subscription)
      end

      it 'assigns all products as @products' do
        patch :update, params: { account_id: account.to_param, id: subscription.to_param, subscription: new_attributes }
        expect(assigns(:products)).to eq(Product.all)
      end

      it 'redirects to the account' do
        patch :update, params: { account_id: account.to_param, id: subscription.to_param, subscription: new_attributes }
        expect(response).to redirect_to(admin_account_path(account))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the subscription' do
        original_licenses = subscription.number_of_licenses
        patch :update,
              params: { account_id: account.to_param, id: subscription.to_param, subscription: invalid_attributes }
        subscription.reload
        expect(subscription.number_of_licenses).to eq(original_licenses)
      end

      it 'assigns the subscription as @subscription' do
        patch :update,
              params: { account_id: account.to_param, id: subscription.to_param, subscription: invalid_attributes }
        expect(assigns(:subscription)).to eq(subscription)
      end

      it 'assigns all products as @products' do
        patch :update,
              params: { account_id: account.to_param, id: subscription.to_param, subscription: invalid_attributes }
        expect(assigns(:subscription)).to eq(subscription)
      end

      it 'returns unprocessable content status' do
        patch :update,
              params: { account_id: account.to_param, id: subscription.to_param, subscription: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription_to_delete) { create(:subscription, account: account, product: product) }

    it 'destroys the requested subscription' do
      expect do
        delete :destroy, params: { account_id: account.to_param, id: subscription_to_delete.to_param }
      end.to change(Subscription, :count).by(-1)
    end

    it 'redirects to the account' do
      delete :destroy, params: { account_id: account.to_param, id: subscription_to_delete.to_param }
      expect(response).to redirect_to(admin_account_path(account))
    end
  end
end
