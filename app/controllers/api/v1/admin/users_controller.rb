module Api
  module V1
    module Admin
      class UsersController < Api::V1::BaseController
        before_action :set_user, only: %i[
          show
          update
          destroy
        ]

        def index
          authorize User

          query = UsersQuery.new(
            User.available,
            params
          )

          users = query.call
          total = query.total_count

          render json: {
            data: ActiveModelSerializers::SerializableResource.new(
              users,
              each_serializer: UserSerializer
            ),
            meta: {
              current_page: query.page,
              per_page: query.per_page,
              total_items: total,
              total_pages: (total.to_f / query.per_page).ceil
            }
          }
        end

        def show
          authorize @user

          render json: @user
        end

        def update
          authorize @user

          user = ::Admin::Users::UpdateService.call(
  user: @user,
  params: user_params,
  actor: Current.user
)
          render json: user
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
          }, status: :unprocessable_entity
        end

        def destroy
          authorize @user

          ::Admin::Users::DestroyService.call(
            user: @user
          )

          head :no_content
        end

        private

        def set_user
          @user = User.available.find(params[:id])
        end

        def user_params
  params.require(:user).permit(
    :name,
    :last_name,
    :phone,
    :role,
    :status,
    :suspended_until
  )
end
      end
    end
  end
end