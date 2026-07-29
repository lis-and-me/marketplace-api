module Api
  module V1
    module Auth
      class RegistrationsController < Api::V1::BaseController
        skip_before_action :authenticate_user!

        def create
          result = Authentication::RegisterService.call(register_params)

          unless result[:success]
            return render json: {
              errors: result[:errors]
            }, status: :unprocessable_entity
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
          }, status: :created
        end

        private

        def register_params
          params.permit(
            :name,
            :last_name,
            :email,
            :password,
            :phone
          )
        end
      end
    end
  end
end