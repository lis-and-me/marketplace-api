module Api
  module V1
    module Admin
      class CategoriesController < Api::V1::BaseController
        before_action :set_category, only: %i[show update destroy]

        def index
          authorize Category

          render json: Category.active.order(:name)
        end

        def show
          authorize @category

          render json: @category
        end

        def create
          authorize Category

          category = Category.new(category_params)

          if category.save
            render json: category, status: :created
          else
            render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          authorize @category

          if @category.update(category_params)
            render json: @category
          else
            render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
          end
        end
def destroy
  authorize @category

  @category.destroy!

  head :no_content
end

        private

        def set_category
          @category = Category.find(params[:id])
        end

      def category_params
  params.require(:category).permit(
    :name,
    :description
  )
end
      end
    end
  end
end