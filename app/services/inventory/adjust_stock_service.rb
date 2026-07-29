module Inventory
  class AdjustStockService
    ALLOWED_TYPES = %w[
      adjustment
      return
      restock
    ].freeze

    def self.call(
      product:,
      quantity:,
      movement_type:,
      note: nil
    )
      new(
        product: product,
        quantity: quantity,
        movement_type: movement_type,
        note: note
      ).call
    end

    def initialize(
      product:,
      quantity:,
      movement_type:,
      note:
    )
      @product = product
      @quantity = quantity.to_i
      @movement_type = movement_type.to_s
      @note = note
    end

    def call
      validate!

      ActiveRecord::Base.transaction do
        @product.with_lock do
          stock_before = @product.stock
          stock_after =
            stock_before + @quantity

          if stock_after.negative?
            @product.errors.add(
              :stock,
              "cannot be negative"
            )

            raise ActiveRecord::RecordInvalid.new(
              @product
            )
          end

          @product.update!(
            stock: stock_after
          )

          Inventory::CreateMovementService.call(
            product: @product,
            quantity: @quantity,
            movement_type: @movement_type,
            stock_before: stock_before,
            stock_after: stock_after,
            note: @note
          )
        end
      end
    end

    private

    def validate!
      unless ALLOWED_TYPES.include?(
        @movement_type
      )
        @product.errors.add(
          :base,
          "Invalid inventory movement type"
        )

        raise ActiveRecord::RecordInvalid.new(
          @product
        )
      end

      return unless @quantity.zero?

      @product.errors.add(
        :base,
        "Quantity cannot be zero"
      )

      raise ActiveRecord::RecordInvalid.new(
        @product
      )
    end
  end
end