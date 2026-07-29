module Orders
  class CreateService
    def self.call(
      user:,
      address:,
      shipping: 0,
      tax: 0,
      discount: 0,
      coupon: nil
    )
      new(
        user: user,
        address: address,
        shipping: shipping,
        tax: tax,
        discount: discount,
        coupon: coupon
      ).call
    end

    def initialize(
      user:,
      address:,
      shipping:,
      tax:,
      discount:,
      coupon:
    )
      @user = user
      @address = address
      @shipping = BigDecimal(shipping.to_s)
      @tax = BigDecimal(tax.to_s)
      @discount = BigDecimal(discount.to_s)
      @coupon = coupon
    end

    def call
      cart = @user.cart

      raise Orders::EmptyCartError,
            "Cart is empty" if cart.blank? || cart.cart_items.empty?

      order = Order.create!(
        user: @user,
        address: @address,
        coupon: @coupon,
        status: :pending,
        subtotal: 0,
        shipping: @shipping,
        tax: @tax,
        discount: @discount,
        total: 0
      )

      cart.cart_items.includes(:product).each do |item|
        order.order_items.create!(
          product: item.product,
          quantity: item.quantity,
          unit_price: item.unit_price
        )
      end

      order.recalculate_totals!

      @coupon&.increment!(:used_count)

      order
    end
  end
end