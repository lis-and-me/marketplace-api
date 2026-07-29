module Api
  module V1
    class ReviewsController < BaseController
      skip_before_action :authenticate_user!, only: %i[index show]

      before_action :set_review, only: %i[show update destroy]

     def index
  authenticate_user_if_present!

  product = Product.find(params[:product_id])

  reviews = policy_scope(
    product.reviews.includes(
      :user,
      :product,
      :rating
    )
  )

  Rails.logger.info "=========================="
  Rails.logger.info "Current.user: #{Current.user&.id}"
  Rails.logger.info "Reviews: #{reviews.pluck(:id, :user_id, :status).inspect}"
  Rails.logger.info "=========================="

  render json: reviews,
         each_serializer: ReviewSerializer,
         scope: Current.user
end

      def show
        authorize @review

        render json: @review,
               serializer: ReviewSerializer,
               scope: Current.user
      end

      def create
        review = Reviews::CreateService.call(
          user: Current.user,
          params: review_params
        )

        authorize review

        render json: review,
               serializer: ReviewSerializer,
               scope: Current.user,
               status: :created
      end

      def update
        authorize @review

        review = Reviews::UpdateService.call(
          review: @review,
          params: review_params
        )

        render json: review,
               serializer: ReviewSerializer,
               scope: Current.user
      end

      def destroy
        authorize @review

        Reviews::DestroyService.call(@review)

        head :no_content
      end

      private

      def set_review
        @review = Review.includes(
          :user,
          :product,
          :rating
        ).find(params[:id])
      end

      def review_params
        params.require(:review).permit(
          :product_id,
          :score,
          :comment
        )
      end
    end
  end
end