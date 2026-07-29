module Api
  module V1
    module Admin
      class BrandsController < Api::V1::BaseController
        before_action :set_brand, only: %i[show update destroy]

        def index
  authorize Brand

  render json: Brand
    .where(active: true)
    .order(id: :asc)
end

        def show
          authorize @brand

          render json: @brand
        end

        def create
          authorize Brand

          brand = Brand.new(brand_params)

          if brand.save
            render json: brand, status: :created
          else
            render json: { errors: brand.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          authorize @brand

          if @brand.update(brand_params)
            render json: @brand
          else
            render json: { errors: @brand.errors.full_messages }, status: :unprocessable_entity
          end
        end

      def destroy
  authorize @brand

  @brand.destroy!

  head :no_content
rescue ActiveRecord::DeleteRestrictionError
  render json: {
    errors: ["No se puede eliminar una marca que tiene productos asociados."]
  }, status: :unprocessable_entity
end

        private

        def set_brand
          @brand = Brand.find(params[:id])
        end

        def brand_params
          params.permit(:name, :description)
        end
      end
    end
  end
end