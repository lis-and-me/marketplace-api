module Api
  module V1
    module Admin
      class OrdersController < Api::V1::BaseController
        before_action :set_order, only: %i[
          show
          update
        ]

        def index
          authorize Order

          query = OrdersQuery.new(
            Order.includes(
              :user,
              :address,
              order_items: :product
            ),
            params
          )

          orders = query.call
          total = query.total_count

          render json: {
            data: ActiveModelSerializers::SerializableResource.new(
              orders,
              each_serializer: OrderSerializer
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
          authorize @order

          render json: @order
        end

        def update
          authorize @order

          order = Orders::UpdateService.call(
            order: @order,
            params: order_params
          )

          render json: order
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
          }, status: :unprocessable_entity
        end

        private

        def set_order
          @order = Order
                     .includes(
                       :user,
                       :address,
                       order_items: :product
                     )
                     .find(params[:id])
        end

        def order_params
          params.require(:order).permit(
            :status,
            :shipping,
            :tax,
            :discount
          )
        end
      end
    end
  end
end