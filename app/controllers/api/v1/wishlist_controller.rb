module Api
  module V1
    class WishlistController < BaseController
      def index
        wishlist_items = policy_scope(
          WishlistItem.includes(:product)
        )

        render json: wishlist_items,
               each_serializer: WishlistItemSerializer
      end

      def create
        wishlist_item = Wishlist::CreateService.call(
          user: Current.user,
          product_id: wishlist_params[:product_id]
        )

        authorize wishlist_item

        render json: wishlist_item,
               serializer: WishlistItemSerializer,
               status: :created

      rescue ActiveRecord::RecordInvalid => e
        render json: {
          errors: e.record.errors.full_messages
        }, status: :unprocessable_entity

      rescue ActiveRecord::RecordNotFound => e
        render json: {
          error: e.message
        }, status: :not_found
      end

      def destroy
        wishlist_item = WishlistItem.find_by!(
          user: Current.user,
          product_id: params[:id]
        )

        authorize wishlist_item

        Wishlist::DestroyService.call(
          user: Current.user,
          product_id: params[:id]
        )

        head :no_content

      rescue ActiveRecord::RecordNotFound => e
        render json: {
          error: e.message
        }, status: :not_found
      end

      private

      def wishlist_params
        params.require(:wishlist).permit(:product_id)
      end
    end
  end
end 