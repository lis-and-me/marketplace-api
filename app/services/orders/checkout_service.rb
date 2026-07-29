module Orders
  class CheckoutService
    def self.call(
  user:,
  address:,
  shipping: 0,
  tax: 0,
  coupon_code: nil,
  payment_method: "oxxo"
)
     new(
  user: user,
  address: address,
  shipping: shipping,
  tax: tax,
  coupon_code: coupon_code,
  payment_method: payment_method
).call
    end

    def initialize(
  user:,
  address:,
  shipping:,
  tax:,
  coupon_code:,
  payment_method:
 
)
      @user = user
      @address = address
      @shipping = shipping
      @tax = tax
      @coupon_code = coupon_code
       @payment_method = payment_method
    end

    def call
      ActiveRecord::Base.transaction do
        cart = @user.cart

        raise ActiveRecord::RecordNotFound, "Cart not found" if cart.nil?
        raise Orders::EmptyCartError, "Cart is empty" if cart.cart_items.empty?

        Orders::StockValidator.call(cart: cart)

        subtotal = cart.cart_items.sum do |item|
          item.quantity * item.unit_price
        end

        coupon = Coupons::ValidateService.call(
          code: @coupon_code,
          subtotal: subtotal
        )

        discount =
          coupon.present? ? coupon.discount_for(subtotal) : 0

    order = Orders::CreateService.call(
  user: @user,
  address: @address,
  shipping: @shipping,
  tax: @tax,
  discount: discount,
  coupon: coupon
)

Coupons::RedeemService.call(
  coupon: coupon
)

payment = Payments::CreateService.call(
  order: order,
  payment_method: @payment_method
)

Orders::StockUpdater.call(
  order: order
)

cart.cart_items.destroy_all

order
      end
    end
  end
end