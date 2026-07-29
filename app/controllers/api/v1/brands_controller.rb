module Api
  module V1
    class BrandsController < Api::V1::BaseController
      skip_before_action :authenticate_user!

      before_action :set_brand, only: :show

      def index
        brands = Brand
          .active
          .order(:name)

        render json: brands,
               each_serializer: BrandSerializer
      end

      def show
        render json: @brand,
               serializer: BrandSerializer
      end

      private

      def set_brand
        @brand = Brand.active.find(params[:id])
      end
    end
  end
end
