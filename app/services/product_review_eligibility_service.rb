class ProductReviewEligibilityService
  def initialize(user:, product:)
    @user = user
    @product = product
  end

  def eligible?
    delivered_order_exists? && !already_reviewed?
  end

  private

  attr_reader :user, :product

  def delivered_order_exists?
    Order.joins(:order_items)
         .where(user:)
         .where(status: :delivered)
         .where(order_items: { product_id: product.id })
         .exists?
  end

  def already_reviewed?
    Review.exists?(
      user:,
      product:
    )
  end
end