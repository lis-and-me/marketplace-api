class Api::V1::BaseController < ActionController::API
  include Authenticable
  include Pundit::Authorization

  before_action :authenticate_user!
  around_action :set_current

  rescue_from Pundit::NotAuthorizedError,
              with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound,
              with: :record_not_found

  rescue_from ActiveRecord::RecordInvalid,
              with: :record_invalid

  private

  def pundit_user
    Current.user
  end

  def set_current
    yield
  ensure
    Current.reset
  end

  def user_not_authorized
    render json: {
      error: "You are not authorized to perform this action."
    }, status: :forbidden
  end

  def record_not_found(exception)
    render json: {
      error: exception.message
    }, status: :not_found
  end

  def record_invalid(exception)
    render json: {
      errors: exception.record.errors.full_messages
    }, status: :unprocessable_entity
  end
end