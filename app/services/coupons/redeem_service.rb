module Coupons
  class RedeemService
    def self.call(coupon:)
      return if coupon.nil?

      coupon.with_lock do
        coupon.reload

        unless coupon.active_now?
          raise StandardError,
                "Coupon is no longer available"
        end

        coupon.increment!(:used_count)
      end
    end
  end
end