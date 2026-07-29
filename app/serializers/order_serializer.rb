class OrderSerializer < ActiveModel::Serializer
  attributes :id,
             :status,
             :subtotal,
             :shipping,
             :tax,
             :discount,
             :total,
             :created_at,
             :updated_at

  belongs_to :user
  belongs_to :address

 has_many :order_items,
         serializer: OrderItemSerializer

has_one :payment,
        serializer: PaymentSerializer
end