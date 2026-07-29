module Api
  module V1
    module Admin
      class ReviewsController < Api::V1::BaseController
        before_action :set_review, only: %i[
          show
          approve
          reject
          destroy
        ]

        def index
          authorize Review

          query = ReviewsQuery.new(
            policy_scope(
              Review.includes(
                :user,
                :product,
                :rating
              )
            ),
            params
          )

          reviews = query.call
          total = query.total_count

          render json: {
            data: ActiveModelSerializers::SerializableResource.new(
              reviews,
              each_serializer: ReviewSerializer
            ),
            meta: {
              current_page: query.page,
              per_page: query.per_page,
              total_items: total,
              total_pages: (total.to_f / query.per_page).ceil
            }
          }
        end

        def stats
          authorize Review, :index?

          reviews = Review.approved

          ratings = Rating
                      .joins(:review)
                      .where(
                        reviews: {
                          status: Review.statuses[:approved]
                        }
                      )

          distribution = ratings
                           .group(:score)
                           .count

          render json: {
            total: reviews.count,
            average_rating: ratings.average(:score).to_f.round(2),
            distribution: {
              5 => distribution[5] || 0,
              4 => distribution[4] || 0,
              3 => distribution[3] || 0,
              2 => distribution[2] || 0,
              1 => distribution[1] || 0
            }
          }
        end

        def show
          authorize @review

          render json: @review
        end

        def approve
          authorize @review

          review = ::Reviews::ApproveService.call(@review)

          render json: review
        end

        def reject
          authorize @review

          review = ::Reviews::RejectService.call(@review)

          render json: review
        end

        def destroy
          authorize @review

          ::Reviews::DestroyService.call(@review)

          head :no_content
        end

        private

        def set_review
          @review = Review
                      .includes(
                        :user,
                        :product,
                        :rating
                      )
                      .find(params[:id])
        end
      end
    end
  end
end