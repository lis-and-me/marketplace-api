module Inventory
  class CreateMovementService
    def self.call(
      product:,
      quantity:,
      movement_type:,
      stock_before:,
      stock_after:,
      order: nil,
      note: nil
    )
      new(
        product: product,
        quantity: quantity,
        movement_type: movement_type,
        stock_before: stock_before,
        stock_after: stock_after,
        order: order,
        note: note
      ).call
    end

    def initialize(
      product:,
      quantity:,
      movement_type:,
      stock_before:,
      stock_after:,
      order:,
      note:
    )
      @product = product
      @quantity = quantity
      @movement_type = movement_type
      @stock_before = stock_before
      @stock_after = stock_after
      @order = order
      @note = note
    end

    def call
      InventoryMovement.create!(
        product: @product,
        order: @order,
        quantity: @quantity,
        movement_type: @movement_type,
        stock_before: @stock_before,
        stock_after: @stock_after,
        note: @note
      )
    end
  end
end