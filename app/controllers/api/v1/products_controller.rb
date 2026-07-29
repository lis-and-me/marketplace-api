module Api
  module V1
    class ProductsController < Api::V1::BaseController
     skip_before_action :authenticate_user!

before_action :authenticate_user_if_present!, only: [:index, :show]
      before_action :set_product, only: :show

      def index
  products = Product
    .available
    .active
    .includes(
      :brand,
      :categories,
      :product_images
    )

  if params[:search].present?
    query = "%#{params[:search].strip.downcase}%"

    products = products.left_joins(:brand, :categories)
                       .where(
                         <<~SQL,
                           LOWER(products.name) LIKE :query
                           OR LOWER(products.description) LIKE :query
                           OR LOWER(brands.name) LIKE :query
                           OR LOWER(categories.name) LIKE :query
                         SQL
                         query: query
                       )
                       .distinct
  end

  products = products.order(created_at: :desc)

  render json: products,
         each_serializer: ProductSerializer
end

      def show
  can_review = false

  if Current.user
    can_review =
      Current.user.orders
                  .where(status: :delivered)
                  .joins(:order_items)
                  .where(order_items: { product_id: @product.id })
                  .exists?
  end

  render json: @product,
         serializer: ProductSerializer,
         can_review: can_review
end

      private

      def set_product
        @product = Product
          .available
          .active
          .includes(
            :brand,
            :categories,
            :product_images
          )
          .find(params[:id])
      end
    end
  end
end
