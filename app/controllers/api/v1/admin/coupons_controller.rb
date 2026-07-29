module Api
  module V1
    module Admin
      class CouponsController < Api::V1::BaseController
        before_action :set_coupon, only: %i[
          show
          update
          destroy
        ]

        def index
          authorize Coupon

          query = CouponsQuery.new(
            policy_scope(Coupon),
            params
          )

          coupons = query.call
          total = query.total_count

          render json: {
            data: ActiveModelSerializers::SerializableResource.new(
              coupons,
              each_serializer: CouponSerializer
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
          authorize @coupon

          render json: @coupon,
                 serializer: CouponSerializer
        end

        def create
          coupon = Coupon.new(coupon_params)

          authorize coupon

          coupon.save!

          render json: coupon,
                 serializer: CouponSerializer,
                 status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
          }, status: :unprocessable_entity
        end

        def update
          authorize @coupon

          @coupon.update!(coupon_params)

          render json: @coupon,
                 serializer: CouponSerializer
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
          }, status: :unprocessable_entity
        end

        def destroy
          authorize @coupon

          @coupon.destroy!

          head :no_content
        end

        private

        def set_coupon
          @coupon = policy_scope(Coupon).find(params[:id])
        end

        def coupon_params
          params.require(:coupon).permit(
            :code,
            :discount_type,
            :value,
            :minimum_amount,
            :usage_limit,
            :active,
            :starts_at,
            :expires_at
          )
        end
      end
    end
  end
end