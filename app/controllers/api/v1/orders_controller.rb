module Api
  module V1
    class OrdersController < BaseController
      before_action :set_order, only: :show
def index
  authorize Order

  orders = policy_scope(Order)
             .includes(
               :address,
               :payment,
               order_items: :product
             )
             .recent

  render json: orders
end

   def show
  authorize @order

  render json: @order
end

      def checkout
        address = Current.user.addresses.find(params[:address_id])

     order = ::Orders::CheckoutService.call(
  user: Current.user,
  address: address,
  shipping: params[:shipping] || 0,
  tax: params[:tax] || 0,
  coupon_code: params[:coupon_code],
  payment_method: params[:payment_method] || "oxxo",
)

        render json: order,
               status: :created

      rescue ActiveRecord::RecordNotFound => e
        render json: {
          error: e.message
        }, status: :not_found

      rescue Orders::EmptyCartError,
             Orders::InsufficientStockError => e
        render json: {
          error: e.message
        }, status: :unprocessable_entity

      rescue ActiveRecord::RecordInvalid => e
        render json: {
          errors: e.record.errors.full_messages
        }, status: :unprocessable_entity
      end

      private

      def set_order
        @order = Current.user.orders
                             .includes(
                               :address,
                               :payment,
                               order_items: :product
                             )
                             .find(params[:id])
      end
    end
  end
end