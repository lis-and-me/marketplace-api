module Api
  module V1
    module Admin
      class InventoryMovementsController < Api::V1::BaseController
        before_action :set_inventory_movement,
                      only: %i[show]

        def index
          authorize InventoryMovement

          query = InventoryMovementsQuery.new(
            InventoryMovement.includes(
              :product,
              :order
            ),
            params
          )

          movements = query.call
          total = query.total_count

          render json: {
            data: ActiveModelSerializers::SerializableResource.new(
              movements,
              each_serializer: InventoryMovementSerializer
            ),
            meta: {
              current_page: query.page,
              per_page: query.per_page,
              total_items: total,
              total_pages:
                (total.to_f / query.per_page).ceil
            }
          }
        end

        def show
          authorize @inventory_movement

          render json: @inventory_movement,
                 serializer: InventoryMovementSerializer
        end

        def create
          authorize InventoryMovement

          product = Product.available.find(
            movement_params[:product_id]
          )

          movement =
            Inventory::AdjustStockService.call(
              product: product,
              quantity: movement_params[:quantity],
              movement_type:
                movement_params[:movement_type],
              note: movement_params[:note]
            )

          render json: movement,
                 serializer: InventoryMovementSerializer,
                 status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
          }, status: :unprocessable_entity
        end

        private

        def set_inventory_movement
          @inventory_movement =
            InventoryMovement
              .includes(:product, :order)
              .find(params[:id])
        end

        def movement_params
          params.require(
            :inventory_movement
          ).permit(
            :product_id,
            :quantity,
            :movement_type,
            :note
          )
        end
      end
    end
  end
end