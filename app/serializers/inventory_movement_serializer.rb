class InventoryMovementSerializer < ActiveModel::Serializer
  attributes :id,
             :movement_type,
             :quantity,
             :stock_before,
             :stock_after,
             :note,
             :product_id,
             :product_name,
             :order_id,
             :created_at

  def product_id
    object.product_id
  end

  def product_name
    object.product.name
  end

  def order_id
    object.order_id
  end
end