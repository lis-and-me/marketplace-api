module Api
  module V1
    module Auth
      class SessionsController < Api::V1::BaseController
        skip_before_action :authenticate_user!

        def create
          result = Authentication::LoginService.call(
            email: params[:email],
            password: params[:password]
          )

          unless result[:success]
            return render json: {
              error: result[:error]
            }, status: :unauthorized
          end

          render json: {
            access_token: result[:access_token],
            refresh_token: result[:refresh_token],
            user: {
              id: result[:user].id,
              name: result[:user].name,
              last_name: result[:user].last_name,
              email: result[:user].email,
              role: result[:user].role
            }
          }
        end
      end
    end
  end
end