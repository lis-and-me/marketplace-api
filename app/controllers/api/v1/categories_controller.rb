module Api
  module V1
    class CategoriesController < Api::V1::BaseController
      skip_before_action :authenticate_user!

      before_action :set_category, only: :show

      def index
        categories = Category
          .active
          .order(:name)

        render json: categories,
               each_serializer: CategorySerializer
      end

      def show
        render json: @category,
               serializer: CategorySerializer
      end

      private

      def set_category
        @category = Category.active.find(params[:id])
      end
    end
  end
end
