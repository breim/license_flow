# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::LicenseAssignmentsController, type: :controller do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }
  let(:product) { create(:product) }
  let(:subscription) { create(:subscription, account: account, product: product, number_of_licenses: 5) }
  let(:license_assignment) { create(:license_assignment, account: account, user: user, product: product) }

  before do
    subscription
  end

  describe 'GET #index' do
    it 'assigns the account as @account' do
      get :index, params: { account_id: account.to_param }
      expect(assigns(:account)).to eq(account)
    end

    it 'assigns account users as @users' do
      user1 = create(:user, account: account)
      user2 = create(:user, account: account)
      create(:user)

      get :index, params: { account_id: account.to_param }
      expect(assigns(:users)).to match_array([user, user1, user2])
    end

    it 'assigns account subscriptions with products as @subscriptions' do
      subscription1 = create(:subscription, account: account)
      subscription2 = create(:subscription, account: account)
      create(:subscription)

      get :index, params: { account_id: account.to_param }
      expect(assigns(:subscriptions)).to match_array([subscription, subscription1, subscription2])
    end

    it 'renders the index template' do
      get :index, params: { account_id: account.to_param }
      expect(response).to render_template(:index)
    end

    it 'returns a successful response' do
      get :index, params: { account_id: account.to_param }
      expect(response).to be_successful
    end

    it 'raises ActiveRecord::RecordNotFound for invalid account_id' do
      expect do
        get :index, params: { account_id: 'invalid' }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST #create' do
    let(:valid_assignment_params) do
      {
        '0' => { user_id: user.id, product_id: product.id },
        '1' => { user_id: create(:user, account: account).id, product_id: product.id }
      }
    end

    let(:invalid_assignment_params) do
      {
        '0' => { user_id: '', product_id: '' }
      }
    end

    context 'with valid parameters' do
      it 'creates license assignments' do
        expect do
          post :create, params: { account_id: account.to_param, assignments: valid_assignment_params }
        end.to change(LicenseAssignment, :count).by(2)
      end

      it 'redirects to the license assignments index' do
        post :create, params: { account_id: account.to_param, assignments: valid_assignment_params }
        expect(response).to redirect_to(admin_account_license_assignments_path(account))
      end

      it 'calls LicenseAssignment.create_batch_for_account with correct parameters' do
        expect(LicenseAssignment).to receive(:create_batch_for_account) do |acc, params|
          expect(acc).to eq(account)
          expect(params).to be_a(ActionController::Parameters)

          expected_params = valid_assignment_params.transform_values do |assignment|
            assignment.transform_keys(&:to_s).transform_values(&:to_s)
          end
          expect(params.to_unsafe_h).to eq(expected_params)
          { success: true, errors: [], assignments: [] }
        end

        post :create, params: { account_id: account.to_param, assignments: valid_assignment_params }
      end
    end

    context 'with invalid parameters' do
      before do
        allow(LicenseAssignment).to receive(:create_batch_for_account)
          .and_return({ success: false, errors: ['Error message 1', 'Error message 2'], assignments: [] })
      end

      it 'does not create license assignments' do
        expect do
          post :create, params: { account_id: account.to_param, assignments: invalid_assignment_params }
        end.not_to change(LicenseAssignment, :count)
      end

      it 'assigns a new license_assignment as @license_assignment' do
        post :create, params: { account_id: account.to_param, assignments: invalid_assignment_params }
        expect(assigns(:license_assignment)).to be_a_new(LicenseAssignment)
      end

      it 'adds errors to the license_assignment model' do
        post :create, params: { account_id: account.to_param, assignments: invalid_assignment_params }
        expect(assigns(:license_assignment).errors.full_messages).to include('Error message 1', 'Error message 2')
      end

      it 'renders the index template with unprocessable_entity status' do
        post :create, params: { account_id: account.to_param, assignments: invalid_assignment_params }
        expect(response).to render_template(:index)
        expect(response.status).to eq(422)
      end

      it 'assigns account users as @users' do
        post :create, params: { account_id: account.to_param, assignments: invalid_assignment_params }
        expect(assigns(:users)).to eq(account.users)
      end

      it 'assigns account subscriptions as @subscriptions' do
        post :create, params: { account_id: account.to_param, assignments: invalid_assignment_params }
        expect(assigns(:subscriptions)).to eq(account.subscriptions.includes(:product))
      end
    end

    context 'with blank assignment parameters' do
      it 'renders index with error when assignments params are blank' do
        post :create, params: { account_id: account.to_param, assignments: {} }
        expect(response).to render_template(:index)
        expect(response.status).to eq(422)
      end

      it 'renders index with error when assignments params are nil' do
        post :create, params: { account_id: account.to_param }
        expect(response).to render_template(:index)
        expect(response.status).to eq(422)
      end
    end

    it 'raises ActiveRecord::RecordNotFound for invalid account_id' do
      expect do
        post :create, params: { account_id: 'invalid', assignments: valid_assignment_params }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'DELETE #destroy' do
    context 'single license assignment destruction' do
      it 'destroys the license assignment' do
        license_assignment
        expect do
          delete :destroy, params: { account_id: account.to_param, id: license_assignment.to_param }
        end.to change(LicenseAssignment, :count).by(-1)
      end

      it 'redirects to the account path' do
        delete :destroy, params: { account_id: account.to_param, id: license_assignment.to_param }
        expect(response).to redirect_to(admin_account_path(account))
      end

      it 'raises ActiveRecord::RecordNotFound for invalid license assignment id' do
        expect do
          delete :destroy, params: { account_id: account.to_param, id: 'invalid' }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'batch license assignment destruction' do
      let(:user1) { create(:user, account: account) }
      let(:user2) { create(:user, account: account) }
      let(:product1) { create(:product) }
      let(:product2) { create(:product) }

      before do
        create(:subscription, account: account, product: product1, number_of_licenses: 5)
        create(:subscription, account: account, product: product2, number_of_licenses: 5)

        create(:license_assignment, account: account, user: user1, product: product1)
        create(:license_assignment, account: account, user: user1, product: product2)
        create(:license_assignment, account: account, user: user2, product: product1)
        create(:license_assignment, account: account, user: user2, product: product2)
      end

      it 'destroys multiple license assignments' do
        user_ids = [user1.id, user2.id]
        product_ids = [product1.id, product2.id]

        expect do
          delete :destroy, params: {
            account_id: account.to_param,
            id: 'batch',
            batch: true,
            user_ids: user_ids,
            product_ids: product_ids
          }
        end.to change(LicenseAssignment, :count).by(-4)
      end

      it 'calls LicenseAssignment.destroy_batch_for_account with correct parameters' do
        user_ids = [user1.id, user2.id]
        product_ids = [product1.id, product2.id]

        expect(LicenseAssignment).to receive(:destroy_batch_for_account)
          .with(account, user_ids.map(&:to_s), product_ids.map(&:to_s))

        delete :destroy, params: {
          account_id: account.to_param,
          id: 'batch',
          batch: true,
          user_ids: user_ids,
          product_ids: product_ids
        }
      end

      it 'redirects to the license assignments index' do
        user_ids = [user1.id, user2.id]
        product_ids = [product1.id, product2.id]

        delete :destroy, params: {
          account_id: account.to_param,
          id: 'batch',
          batch: true,
          user_ids: user_ids,
          product_ids: product_ids
        }
        expect(response).to redirect_to(admin_account_license_assignments_path(account))
      end

      it 'does not call destroy_batch when user_ids is empty' do
        expect(LicenseAssignment).not_to receive(:destroy_batch_for_account)

        delete :destroy, params: {
          account_id: account.to_param,
          id: 'batch',
          batch: true,
          user_ids: [],
          product_ids: [product1.id]
        }
      end

      it 'does not call destroy_batch when product_ids is empty' do
        expect(LicenseAssignment).not_to receive(:destroy_batch_for_account)

        delete :destroy, params: {
          account_id: account.to_param,
          id: 'batch',
          batch: true,
          user_ids: [user1.id],
          product_ids: []
        }
      end

      it 'handles single user_id and product_id as strings' do
        expect(LicenseAssignment).to receive(:destroy_batch_for_account)
          .with(account, [user1.id.to_s], [product1.id.to_s])

        delete :destroy, params: {
          account_id: account.to_param,
          id: 'batch',
          batch: true,
          user_ids: user1.id.to_s,
          product_ids: product1.id.to_s
        }
      end
    end

    it 'raises ActiveRecord::RecordNotFound for invalid account_id' do
      expect do
        delete :destroy, params: { account_id: 'invalid', id: license_assignment.to_param }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
