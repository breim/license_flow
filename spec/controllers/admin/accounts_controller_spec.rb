# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AccountsController, type: :controller do
  let(:account) { create(:account) }
  let(:valid_attributes) { { name: 'Test Account' } }
  let(:invalid_attributes) { { name: '' } }

  describe 'GET #index' do
    it 'assigns all accounts as @accounts' do
      account1 = create(:account)
      account2 = create(:account)
      get :index
      expect(assigns(:accounts)).to match_array([account1, account2])
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
    it 'assigns the requested account as @account' do
      get :show, params: { id: account.to_param }
      expect(assigns(:account)).to eq(account)
    end

    it 'renders the show template' do
      get :show, params: { id: account.to_param }
      expect(response).to render_template(:show)
    end

    it 'returns a successful response' do
      get :show, params: { id: account.to_param }
      expect(response).to be_successful
    end

    it 'raises ActiveRecord::RecordNotFound for invalid id' do
      expect do
        get :show, params: { id: 'invalid' }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested account as @account' do
      get :edit, params: { id: account.to_param }
      expect(assigns(:account)).to eq(account)
    end

    it 'renders the edit template' do
      get :edit, params: { id: account.to_param }
      expect(response).to render_template(:edit)
    end

    it 'returns a successful response' do
      get :edit, params: { id: account.to_param }
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
      let(:new_attributes) { { name: 'Updated Account Name' } }

      it 'updates the requested account' do
        patch :update, params: { id: account.to_param, account: new_attributes }
        account.reload
        expect(account.name).to eq('Updated Account Name')
      end

      it 'assigns the account as @account' do
        patch :update, params: { id: account.to_param, account: new_attributes }
        expect(assigns(:account)).to eq(account)
      end

      it 'redirects to the account' do
        patch :update, params: { id: account.to_param, account: new_attributes }
        expect(response).to redirect_to(admin_account_path(account))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the account' do
        original_name = account.name
        patch :update, params: { id: account.to_param, account: invalid_attributes }
        account.reload
        expect(account.name).to eq(original_name)
      end

      it 'assigns the account as @account' do
        patch :update, params: { id: account.to_param, account: invalid_attributes }
        expect(assigns(:account)).to eq(account)
      end

      it 'renders the edit template' do
        patch :update, params: { id: account.to_param, account: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end

    it 'raises ActiveRecord::RecordNotFound for invalid id' do
      expect do
        patch :update, params: { id: 'invalid', account: valid_attributes }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #new' do
    it 'assigns a new account as @account' do
      get :new
      expect(assigns(:account)).to be_a_new(Account)
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
      it 'creates a new Account' do
        expect do
          post :create, params: { account: valid_attributes }
        end.to change(Account, :count).by(1)
      end

      it 'assigns a newly created account as @account' do
        post :create, params: { account: valid_attributes }
        expect(assigns(:account)).to be_a(Account)
        expect(assigns(:account)).to be_persisted
      end

      it 'redirects to the created account' do
        post :create, params: { account: valid_attributes }
        expect(response).to redirect_to(admin_account_path(Account.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Account' do
        expect do
          post :create, params: { account: invalid_attributes }
        end.not_to change(Account, :count)
      end

      it 'assigns a newly created but unsaved account as @account' do
        post :create, params: { account: invalid_attributes }
        expect(assigns(:account)).to be_a_new(Account)
      end

      it 'renders the new template' do
        post :create, params: { account: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end
end
