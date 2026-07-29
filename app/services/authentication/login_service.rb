module Authentication
  class LoginService
    def self.call(email:, password:)
      user = User.available.find_by(
        email: email.to_s.downcase.strip
      )

      unless user&.authenticate(password)
        return {
          success: false,
          error: "Invalid email or password"
        }
      end

      # Si la suspensión temporal ya terminó,
      # reactivamos al usuario.
      if user.suspension_expired?
        user.update!(
          status: :active,
          suspended_until: nil
        )
      end

      # Si continúa suspendido, no puede iniciar sesión.
      if user.suspended?
        return {
          success: false,
          error: suspension_message(user),
          code: :suspended
        }
      end

      # Tampoco permitimos login a cuentas que
      # todavía estén pendientes de verificación.
      unless user.active?
        return {
          success: false,
          error: "Account is not active",
          code: :inactive
        }
      end

      access_token =
        JwtService.generate_access_token(user)

      refresh_token =
        JwtService.generate_refresh_token

      user.refresh_tokens.create!(
        token: refresh_token,
        expires_at:
          JwtService::REFRESH_TOKEN_EXPIRATION.from_now
      )

      user.update!(
        last_login_at: Time.current
      )

      {
        success: true,
        access_token: access_token,
        refresh_token: refresh_token,
        user: user
      }
    end

    private

    def self.suspension_message(user)
      if user.suspended_until.present?
        "Account suspended until #{user.suspended_until.iso8601}"
      else
        "Account suspended indefinitely"
      end
    end
  end
end 