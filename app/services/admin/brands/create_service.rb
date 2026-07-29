module Admin
  module Brands
    class CreateService
      def self.call(params)
        brand = Brand.new(params)

        if brand.save
          {
            success: true,
            brand: brand
          }
        else
          {
            success: false,
            errors: brand.errors.full_messages
          }
        end
      end
    end
  end
end