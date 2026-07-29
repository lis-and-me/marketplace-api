module Api
  module V1
    class CartController < BaseController
      def show
        render json: current_cart,
               serializer: CartSerializer
      end

      def add_item
        cart = Current.user.cart

        product = Product.find(create_params[:product_id])
        quantity = (create_params[:quantity] || 1).to_i

        unless product.active?
          return render json: {
            error: "Product is not available."
          }, status: :unprocessable_entity
        end

        item = cart.cart_items.find_or_initialize_by(product: product)

        new_quantity =
          item.new_record? ? quantity : item.quantity + quantity

        if new_quantity > product.stock
          return render json: {
            error: "Not enough stock available."
          }, status: :unprocessable_entity
        end

        if item.new_record?
          item.quantity = quantity
          item.unit_price = product.price
        else
          item.quantity = new_quantity
        end

        item.save!

        render json: current_cart,
               serializer: CartSerializer,
               status: :created
      end

      def update_item
        item = Current.user.cart.cart_items.find(params[:id])

        quantity = update_params[:quantity].to_i

        if quantity <= 0
          return render json: {
            error: "Quantity must be greater than zero."
          }, status: :unprocessable_entity
        end

        if quantity > item.product.stock
          return render json: {
            error: "Not enough stock available."
          }, status: :unprocessable_entity
        end

        item.update!(quantity: quantity)

        render json: current_cart,
               serializer: CartSerializer
      end

      def remove_item
        item = Current.user.cart.cart_items.find(params[:id])

        item.destroy!

        render json: current_cart,
               serializer: CartSerializer
      end

      private

      def current_cart
        Cart.includes(
          cart_items: {
            product: [
              :brand,
              :categories,
              :product_images
            ]
          }
        ).find(Current.user.cart.id)
      end

      def create_params
        params.require(:cart).permit(
          :product_id,
          :quantity
        )
      end

      def update_params
        params.require(:cart).permit(
          :quantity
        )
      end
    end
  end
end