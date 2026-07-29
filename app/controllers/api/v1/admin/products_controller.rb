module Api
  module V1
    module Admin
      class ProductsController < Api::V1::BaseController
        before_action :set_product, only: %i[
          show
          update
          destroy
        ]

        def index
          authorize Product

          query = ProductsQuery.new(
            Product
              .available
              .includes(
                :brand,
                :categories,
                :product_images
              ),
            params
          )

          products = query.call
          total = query.total_count

          render json: {
            data: ActiveModelSerializers::SerializableResource.new(
              products,
              each_serializer: ProductSerializer
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
          authorize @product

          render json: @product
        end

        def create
          authorize Product

          product = Products::CreateService.call(product_params)

          render json: product, status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
          }, status: :unprocessable_entity
        end

        def update
          authorize @product

          product = Products::UpdateService.call(
            @product,
            product_params
          )

          render json: product
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
          }, status: :unprocessable_entity
        end

        def destroy
          authorize @product

          Products::DestroyService.call(@product)

          head :no_content
        end

        private

        def set_product
          @product = Product
                       .available
                       .includes(
                         :brand,
                         :categories,
                         :product_images
                       )
                       .find(params[:id])
        end

        def product_params
          params.require(:product).permit(
            :brand_id,
            :name,
            :slug,
            :description,
            :sku,
            :price,
            :stock,
            :active,
            category_ids: []
          )
        end
      end
    end
  end
end