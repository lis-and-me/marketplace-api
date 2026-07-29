module Coupons
  class ValidateService
    def self.call(code:, subtotal:)
      new(code:, subtotal:).call
    end

    def initialize(code:, subtotal:)
      @code = code
      @subtotal = subtotal
    end

    def call
      return nil if @code.blank?

      coupon = Coupon.find_by!(code: @code.upcase)

      raise StandardError, "Coupon is inactive" unless coupon.active_now?

      if @subtotal < coupon.minimum_amount
        raise StandardError,
              "Minimum purchase amount is #{coupon.minimum_amount}"
      end

      coupon
    end
  end
end