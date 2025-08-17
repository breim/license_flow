# frozen_string_literal: true

module Admin
  class LicenseAssignmentsController < Admin::AdminController
    before_action :set_account
    before_action :set_users_and_subscriptions, only: %i[index create]

    def index; end

    def create
      return render_index_with_error if assignment_params.blank?

      @license_assignment = LicenseAssignment.new

      result = LicenseAssignment.create_batch_for_account(@account, assignment_params)

      if result[:success]
        redirect_to admin_account_license_assignments_path(@account)
      else
        add_errors_to_model(result[:errors])
        render_index_with_error
      end
    end

    def destroy
      if batch_destruction?
        handle_batch_destruction
      else
        handle_single_destruction
      end
    end

    private

    def set_account
      @account = Account.find(params[:account_id])
    end

    def set_users_and_subscriptions
      @users = @account.users
      @subscriptions = @account.subscriptions.includes(:product)
    end

    def assignment_params
      params[:assignments] || {}
    end

    def add_errors_to_model(errors)
      errors.each do |error_message|
        @license_assignment.errors.add(:base, error_message) unless
          @license_assignment.errors.full_messages.include?(error_message)
      end
    end

    def render_index_with_error
      render :index, status: :unprocessable_content
    end

    def batch_destruction?
      params[:batch].present?
    end

    def handle_single_destruction
      license_assignment = LicenseAssignment.find(params[:id])
      license_assignment.destroy
      respond_with(:admin, location: admin_account_path(@account))
    end

    def handle_batch_destruction
      user_ids = Array(params[:user_ids])
      product_ids = Array(params[:product_ids])

      LicenseAssignment.destroy_batch_for_account(@account, user_ids, product_ids) if user_ids.any? && product_ids.any?
      redirect_to admin_account_license_assignments_path(@account)
    end
  end
end
