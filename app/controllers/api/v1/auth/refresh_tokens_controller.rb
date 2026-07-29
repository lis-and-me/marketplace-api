module Api
  module V1
    module Auth
      class RefreshTokensController < Api::V1::BaseController
        skip_before_action :authenticate_user!

        def create
          refresh_token = RefreshToken.active.find_by(
            token: params[:refresh_token]
          )

          unless refresh_token
            return render json: {
              error: "Invalid refresh token"
            }, status: :unauthorized
          end

          user = refresh_token.user

          # Si la suspensión temporal ya venció,
          # reactivamos la cuenta.
          if user.suspension_expired?
            user.update!(
              status: :active,
              suspended_until: nil
            )
          end

          # Una cuenta suspendida no puede
          # renovar su sesión.
          if user.suspended?
            refresh_token.revoke!

            return render json: {
              error: suspension_message(user),
              code: "account_suspended",
              suspended_until: user.suspended_until
            }, status: :forbidden
          end

          # Tampoco renovamos sesiones de
          # cuentas que no estén activas.
          unless user.active?
            refresh_token.revoke!

            return render json: {
              error: "Account is not active",
              code: "account_inactive"
            }, status: :forbidden
          end

          # Rotación del refresh token.
          refresh_token.revoke!

          new_refresh_token =
            JwtService.generate_refresh_token

          user.refresh_tokens.create!(
            token: new_refresh_token,
            expires_at:
              JwtService::REFRESH_TOKEN_EXPIRATION.from_now
          )

          access_token =
            JwtService.generate_access_token(user)

          render json: {
            access_token: access_token,
            refresh_token: new_refresh_token
          }
        end

        def destroy
          refresh_token = RefreshToken.find_by(
            token: params[:refresh_token]
          )

          refresh_token&.revoke!

          head :no_content
        end

        private

        def suspension_message(user)
          if user.suspended_until.present?
            "Account suspended until #{user.suspended_until.iso8601}"
          else
            "Account suspended indefinitely"
          end
        end
      end
    end
  end
end