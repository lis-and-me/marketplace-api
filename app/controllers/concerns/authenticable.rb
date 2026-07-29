module Authenticable
  extend ActiveSupport::Concern

  private

  def authenticate_user!
    Rails.logger.info "Authorization: #{request.headers['Authorization'].inspect}"
    header =
      request.headers["Authorization"]

    return unauthorized! if header.blank?

    token = header.split.last

    payload = JwtService.decode(token)

    return unauthorized! if payload.blank?

    user = User.available.find_by(
      id: payload[:user_id]
    )

    return unauthorized! if user.blank?

    # Una suspensión temporal vencida
    # reactiva la cuenta.
    if user.suspension_expired?
      user.update!(
        status: :active,
        suspended_until: nil
      )
    end

    # Un token existente tampoco sirve
    # mientras la cuenta esté suspendida.
    if user.suspended?
      return suspended!(user)
    end

    # Solo las cuentas activas pueden
    # consumir endpoints autenticados.
    return inactive! unless user.active?

    Current.user = user
    Current.token = token
  end

  def suspended!(user)
    message =
      if user.suspended_until.present?
        "Account suspended until #{user.suspended_until.iso8601}"
      else
        "Account suspended indefinitely"
      end

    render json: {
      error: message,
      code: "account_suspended",
      suspended_until: user.suspended_until
    }, status: :forbidden
  end

  def inactive!
    render json: {
      error: "Account is not active",
      code: "account_inactive"
    }, status: :forbidden
  end

  def unauthorized!
    render json: {
      error: "Unauthorized"
    }, status: :unauthorized
  end
  def authenticate_user_if_present!
  header = request.headers["Authorization"]
  return if header.blank?

  token = header.split.last

  payload = JwtService.decode(token)
  return if payload.blank?

  user = User.available.find_by(id: payload[:user_id])
  return if user.blank?

  return unless user.active?

  Current.user = user
  Current.token = token
end
end